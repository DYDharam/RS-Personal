public class deepClone implements Queueable {

	//global describe to hold object describe data for query building and relationship iteration
	public map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();

	//holds the data to be cloned. Keyed by object type. Contains cloneData which contains the object to clone, and some data needed for queries
	public map<string,cloneData> thisInvocationCloneMap = new map<string,cloneData>();

	//should the clone process be all or nothing?
	public boolean allOrNothing = false;

	//each iteration adds the records it creates to this property so in the event of an error we can roll it all back
	public list<id> allCreatedObjects = new list<id>();

	//only clone custom objects. Helps to avoid trying to clone system objects like chatter posts and such.
	public boolean onlyCloneCustomObjects = true;

	public static id clone(id sObjectId, boolean onlyCustomObjects, boolean allOrNothing)
		{

			deepClone startClone= new deepClone();
			startClone.onlyCloneCustomObjects  = onlyCustomObjects;
			startClone.allOrNothing = allOrNothing;

			sObject thisObject = sObjectId.getSobjectType().newSobject(sObjectId);
			cloneData thisClone = new cloneData(new list<sObject>{thisObject}, new map<id,id>());
			map<string,cloneData> cloneStartMap = new map<string,cloneData>();

			cloneStartMap.put(sObjectId.getSobjectType().getDescribe().getName(),thisClone);

			startClone.thisInvocationCloneMap = cloneStartMap;
			return System.enqueueJob(startClone);

			return null;
		}

	public void execute(QueueableContext context) {
		deepCloneBatched();
	}

	/**
	* @description Clones an object and the entire related data hierarchy. Currently only clones custom objects, but enabling standard objects is easy. It is disabled because it increases risk of hitting governor limits
	* @param sObject objectToClone the root object be be cloned. All descended custom objects will be cloned as well
	* @return list<sobject> all of the objects that were created during the clone.
	**/
	public list<id> deepCloneBatched()
		{
			map<string,cloneData> nextInvocationCloneMap = new map<string,cloneData>();

			//iterate over every object type in the public map
			for(string relatedObjectType : thisInvocationCloneMap.keySet())
				{
					list<sobject> objectsToClone = thisInvocationCloneMap.get(relatedObjectType).objectsToClone;
					map<id,id> previousSourceToCloneMap = thisInvocationCloneMap.get(relatedObjectType).previousSourceToCloneMap;

					system.debug('\n\n\n--------------------  Cloning record ' + objectsToClone.size() + ' records');
					list<id> objectIds = new list<id>();
					list<sobject> clones = new list<sobject>();
					list<sObject> newClones = new list<sObject>();
					map<id,id> sourceToCloneMap = new map<id,id>();
					list<database.saveresult> cloneInsertResult;

					//if this function has been called recursively, then the previous batch of cloned records
					//have not been inserted yet, so now they must be before we can continue. Also, in that case
					//because these are already clones, we do not need to clone them again, so we can skip that part
					if(objectsToClone[0].Id == null)
					{
						//if they don't have an id that means these records are already clones. So just insert them with no need to clone beforehand.
						cloneInsertResult = database.insert(objectsToClone,allOrNothing);

						clones.addAll(objectsToClone);

						for(sObject thisClone : clones)
							{
								sourceToCloneMap.put(thisClone.getCloneSourceId(),thisClone.Id);
							}

						objectIds.addAll(new list<id>(previousSourceToCloneMap.keySet()));
						//get the ids of all these objects.
					}
					else
					{
						//get the ids of all these objects.
						for(sObject thisObj :objectsToClone)
							{
								objectIds.add(thisObj.Id);
							}

						//create a select all query to get all the data for these objects since if we only got passed a basic sObject without data
						//then the clone will be empty
						string objectDataQuery = buildSelectAllStatment(relatedObjectType);

						//add a where condition
						objectDataQuery += ' where id in :objectIds';

						//get the details of this object
						list<sObject> objectToCloneWithData = database.query(objectDataQuery);

						for(sObject thisObj : objectToCloneWithData)
							{
								sObject clonedObject = thisObj.clone(false,true,false,false);
								clones.add(clonedObject);
							}

						//insert the clones
						cloneInsertResult = database.insert(clones,allOrNothing);

						for(sObject thisClone : clones)
							{
								sourceToCloneMap.put(thisClone.getCloneSourceId(),thisClone.Id);
							}
					}

					for(database.saveResult saveResult :  cloneInsertResult)
						{
							if(saveResult.success)
							{
								allCreatedObjects.add(saveResult.getId());
							}
							else if(allOrNothing)
							{
								cleanUpError();
								return allCreatedObjects;
							}
						}

					//Describes this object type so we can deduce it's child relationships
					Schema.DescribeSObjectResult objectDescribe = globalDescribeMap.get(relatedObjectType).getDescribe();

					//get this objects child relationship types
					List<Schema.ChildRelationship> childRelationships = objectDescribe.getChildRelationships();

					system.debug('\n\n\n-------------------- ' + objectDescribe.getName() + ' has ' + childRelationships.size() + ' child relationships');

					//then have to iterate over every child relationship type, and every record of that type and clone them as well.
					for(Schema.ChildRelationship thisRelationship : childRelationships)
						{

							Schema.DescribeSObjectResult childObjectDescribe = thisRelationship.getChildSObject().getDescribe();
							string relationshipField = thisRelationship.getField().getDescribe().getName();

							try
							{
								system.debug('\n\n\n-------------------- Looking at ' + childObjectDescribe.getName() + ' which is a child object of ' + objectDescribe.getName());

								if(!childObjectDescribe.isCreateable() || !childObjectDescribe.isQueryable())
								{
									system.debug('-------------------- Object is not one of the following: queryable, creatable. Skipping attempting to clone this object');
									continue;
								}
								if(onlyCloneCustomObjects && !childObjectDescribe.isCustom())
								{
									system.debug('-------------------- Object is not custom and custom object only clone is on. Skipping this object.');
									continue;
								}
								if(Limits.getQueries() >= Limits.getLimitQueries())
								{
									system.debug('\n\n\n-------------------- Governor limits hit. Must abort.');

									//if we hit an error, and this is an all or nothing job, we have to delete what we created and abort
									if(!allOrNothing)
									{
										cleanUpError();
									}
									return allCreatedObjects;
								}
								//create a select all query from the child object type
								string childDataQuery = buildSelectAllStatment(childObjectDescribe.getName());

								//add a where condition that will only find records that are related to this record. The field which the relationship is defined is stored in the maps value
								childDataQuery+= ' where '+relationshipField+ ' in :objectIds';

								//get the details of this object
								list<sObject> childObjectsWithData = database.query(childDataQuery);

								system.debug('\n\n\n-------------------- Object queried. Found ' + childObjectsWithData.size() + ' records to clone');

								if(!childObjectsWithData.isEmpty())
								{
									map<id,id> childRecordSourceToClone = new map<id,id>();

									for(sObject thisChildObject : childObjectsWithData)
										{
											childRecordSourceToClone.put(thisChildObject.Id,null);

											//clone the object
											sObject newClone = thisChildObject.clone();

											//since the record we cloned still has the original parent id, we now need to update the clone with the id of it's cloned parent.
											//to do that we reference the map we created above and use it to get the new cloned parent.
											system.debug('\n\n\n----------- Attempting to change parent of clone....');
											id newParentId = sourceToCloneMap.get((id) thisChildObject.get(relationshipField));

											system.debug('Old Parent: ' + thisChildObject.get(relationshipField) + ' new parent ' + newParentId);

											//write the new parent value into the record
											newClone.put(thisRelationship.getField().getDescribe().getName(),newParentId );

											//add this new clone to the list. It will be inserted once the deepClone function is called again. I know it's a little odd to not just insert them now
											//but it save on redudent logic in the long run.
											newClones.add(newClone);
										}
									cloneData thisCloneData = new cloneData(newClones,childRecordSourceToClone);
									nextInvocationCloneMap.put(childObjectDescribe.getName(),thisCloneData);
								}

							}
							catch(exception e)
							{
								system.debug('\n\n\n---------------------- Error attempting to clone child records of type: ' + childObjectDescribe.getName());
								system.debug(e);
							}
						}
				}

			system.debug('\n\n\n-------------------- Done iterating cloneable objects.');

			system.debug('\n\n\n-------------------- Clone Map below');
			system.debug(nextInvocationCloneMap);

			system.debug('\n\n\n-------------------- All created object ids thus far across this invocation');
			system.debug(allCreatedObjects);

			//if our map is not empty that means we have more records to clone. So queue up the next job.
			if(!nextInvocationCloneMap.isEmpty())
			{
				system.debug('\n\n\n-------------------- Clone map is not empty. Sending objects to be cloned to another job');

				deepClone nextIteration = new deepClone();
				nextIteration.thisInvocationCloneMap = nextInvocationCloneMap;
				nextIteration.allCreatedObjects = allCreatedObjects;
				nextIteration.onlyCloneCustomObjects  = onlyCloneCustomObjects;
				nextIteration.allOrNothing = allOrNothing;
				id  jobId = System.enqueueJob(nextIteration);

				system.debug('\n\n\n-------------------- Next queable job scheduled. Id is: ' + jobId);
			}

			system.debug('\n\n\n-------------------- Cloneing Done!');

			return allCreatedObjects;
		}

	/**
	* @description create a string which is a select statement for the given object type that will select all fields. Equivalent to Select * from objectName ins SQL
	* @param objectName the API name of the object which to build a query string for
	* @return string a string containing the SELECT keyword, all the fields on the specified object and the FROM clause to specify that object type. You may add your own where statements after.
	**/
	public string buildSelectAllStatment(string objectName){ return buildSelectAllStatment(objectName, new list<string>());}
	public string buildSelectAllStatment(string objectName, list<string> extraFields)
		{
			// Initialize setup variables
			String query = 'SELECT ';
			String objectFields = String.Join(new list<string>(globalDescribeMap.get(objectName).getDescribe().fields.getMap().keySet()),',');
			if(extraFields != null)
			{
				objectFields += ','+String.Join(extraFields,',');
			}

			objectFields = objectFields.removeEnd(',');

			query += objectFields;

			// Add FROM statement
			query += ' FROM ' + objectName;

			return query;
		}

	public void cleanUpError()
		{
			database.delete(allCreatedObjects);
		}

	public class cloneData
	{
		public list<sObject> objectsToClone = new list<sObject>();
		public map<id,id> previousSourceToCloneMap = new map<id,id>();

		public cloneData(list<sObject> objects, map<id,id> previousDataMap)
			{
				this.objectsToClone = objects;
				this.previousSourceToCloneMap = previousDataMap;
			}
	}
}