/*
 * Created by Cloud Analogy on 3/9/2019.
 */
public class DeepCloneController {
	public static list<sObject> deepCloneBatched(list<sObject> objectsToClone, map<id, id> previousSourceToCloneMap)
		{
			system.debug('\n\n\n--------------------  Cloning record ' + objectsToClone.size() + ' records');
			list<id> objectIds = new list<id>();
			list<sobject> clones = new list<sobject>();
			list<sObject> newClones = new list<sObject>();
			map<id, id> sourceToCloneMap = new map<id, id>();


			if (objectsToClone.isEmpty())
			{
				system.debug('\n\n\n-------------------- No records in set to clone. Aborting');
				return clones;
			}

			//if this function has been called recursively, then the previous batch of cloned records
			//have not been inserted yet, so now they must be before we can continue. Also, in that case
			//because these are already clones, we do not need to clone them again, so we can skip that part
			if (objectsToClone[0].Id == null)
			{
				//if they don't have an id that means these records are already clones. So just insert them with no need to clone beforehand.
				insert objectsToClone;
				clones.addAll(objectsToClone);

				for (sObject thisClone : clones)
					{
						sourceToCloneMap.put(thisClone.getCloneSourceId(), thisClone.Id);
					}

				objectIds.addAll(new list<id>(previousSourceToCloneMap.keySet()));
				//get the ids of all these objects.
			} else
			{
				//get the ids of all these objects.
				for (sObject thisObj : objectsToClone)
					{
						objectIds.add(thisObj.Id);
					}

				for (sObject thisObj : objectsToClone)
					{
						sObject clonedObject = thisObj.clone(false, true, false, false);
						clones.add(clonedObject);
					}

				//insert the clones
				insert clones;

				for (sObject thisClone : clones)
					{
						sourceToCloneMap.put(thisClone.getCloneSourceId(), thisClone.Id);
					}
			}

			//figure out what kind of object we are dealing with
			string relatedObjectType = objectsToClone[0].Id.getSobjectType().getDescribe().getName();

			//Describes this object type so we can deduce it's child relationships
			Schema.DescribeSObjectResult objectDescribe = Account.sObjectType.getDescribe();//globalDescribeMap.get(relatedObjectType).getDescribe();

			//get this objects child relationship types
			List<Schema.ChildRelationship> childRelationships = objectDescribe.getChildRelationships();

			system.debug('\n\n\n-------------------- ' + objectDescribe.getName() + ' has ' +
					childRelationships.size() + ' child relationships');

			//then have to iterate over every child relationship type, and every record of that type and clone them as well.
			for (Schema.ChildRelationship thisRelationship : childRelationships)
				{

					Schema.DescribeSObjectResult childObjectDescribe = thisRelationship.getChildSObject().getDescribe();
					string relationshipField = thisRelationship.getField().getDescribe().getName();

					try
					{
						system.debug('\n\n\n-------------------- Looking at ' + childObjectDescribe.getName() +
								' which is a child object of ' + objectDescribe.getName());

						if (!childObjectDescribe.isCreateable() || !childObjectDescribe.isQueryable() ||
								!childObjectDescribe.isCustom())
						{
							system.debug(
									'-------------------- Object is not one of the following: queryable, creatable, or custom. Skipping attempting to clone this object');
							continue;
						}
						if (Limits.getQueries() >= Limits.getLimitQueries())
						{
							system.debug('\n\n\n-------------------- Governor limits hit. Must abort.');
							return clones;
						}
						//create a select all query from the child object type
						string childDataQuery = String.valueOf(thisRelationship.getChildSobject());//buildSelectAllStatment(childObjectDescribe.getName());

						//add a where condition that will only find records that are related to this record. The field which the relationship is defined is stored in the maps value
						childDataQuery += ' where ' + relationshipField + ' in :objectIds';

						//get the details of this object
						list<sObject> childObjectsWithData = database.query(childDataQuery);

						if (!childObjectsWithData.isEmpty())
						{
							map<id, id> childRecordSourceToClone = new map<id, id>();

							for (sObject thisChildObject : childObjectsWithData)
								{
									childRecordSourceToClone.put(thisChildObject.Id, null);

									//clone the object
									sObject newClone = thisChildObject.clone();

									//since the record we cloned still has the original parent id, we now need to update the clone with the id of it's cloned parent.
									//to do that we reference the map we created above and use it to get the new cloned parent.
									system.debug('\n\n\n----------- Attempting to change parent of clone....');
									id newParentId = sourceToCloneMap.get((id) thisChildObject.get(relationshipField));

									system.debug('Old Parent: ' + thisChildObject.get(relationshipField) +
											' new parent ' + newParentId);

									//write the new parent value into the record
									newClone.put(thisRelationship.getField().getDescribe().getName(), newParentId);

									//add this new clone to the list. It will be inserted once the deepClone function is called again. I know it's a little odd to not just insert them now
									//but it save on redudent logic in the long run.
									newClones.add(newClone);
								}
							//now we need to call this function again, passing in the newly cloned records, so they can be inserted, as well as passing in the ids of the original records
							//that spawned them so the next time the query can find the records that currently exist that are related to the kind of records we just cloned.
							clones.addAll(deepCloneBatched(newClones, childRecordSourceToClone));
						}
					} catch (exception e)
					{
						system.debug('\n\n\n---------------------- Error attempting to clone child records of type: ' +
								childObjectDescribe.getName());
						system.debug(e);
					}
				}

			return clones;
		}
}