/*;
 * Created by DY on 3/12/2019.
 */
public class CopyQuoteController {

    public static List<String> relatedListIds {set; get;}
    /*public static List<sObjectType> getAllRealtedListFromSobject_Apex() {
		List<sObjectType> prettyPrint = new List<sObjectType>();
		try {
			Schema.DescribeSObjectResult R = CanaryAMS__Insurance_Product__c.SObjectType.getDescribe();
			for (Schema.ChildRelationship cr : R.getChildRelationships())
				{
					String customSObjectName = String.valueOf(cr.getChildSobject());
					if (customSObjectName.contains('__c') &&
							(customSObjectName.contains('CanaryAMS') || customSObjectName.contains('CanaryBMS')) &&
							!customSObjectName.contains('CanaryAMS__Documents__c') &&
							!customSObjectName.contains('CanaryAMS__Accord_PDF__c') &&
							!customSObjectName.contains('CanaryAMS__Policy__c')
					) {
						system.debug('====child object===' + cr.getChildSObject());
						prettyPrint.add(cr.getChildSObject());
					}

				}
			system.debug('prettyPrint-->> ' + prettyPrint.size());
		} catch (Exception e) {
			System.debug('Get exception on line number ' + e.getLineNumber() +
					'   due to following method getRecordType  ' + e.getMessage());
		}
		return prettyPrint;
	}
	public static String getFieldsNameFromObjectName_Apex (String sObjectName) {
		String allFieldsApiNames = '';
		try {
			if(String.isNotBlank(sObjectName)) {
				SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
				DescribeSObjectResult objDef = objToken.getDescribe();
				Map<String, SObjectField> fields = objDef.fields.getMap();
				Set<String> fieldSet = fields.keySet();
				for(String s:fieldSet)
					{
						SObjectField fieldToken = fields.get(s);
						DescribeFieldResult selectedField = fieldToken.getDescribe();
						allFieldsApiNames += String.valueOf(selectedField.getName() + ',');
					}
				system.debug('allFieldsApiNames->>> '+allFieldsApiNames);
			}
		} catch (Exception e) {
			System.debug('Get exception on line number ' + e.getLineNumber() +
					'   due to following method getRecordType  ' + e.getMessage());
		}
		return allFieldsApiNames;
	}
	public static List<SObject> queryString(String sObjectType, String commaDelimitedFields) {
		String soql = '';
		SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
		Map<String, SObjectField> fieldsMap = schemaType.getDescribe().fields.getMap();
		List<String> fields = new List<String>();
		for (String field : commaDelimitedFields.split(',')) {
			if (fieldsMap.get(field).getDescribe().isAccessible()) {
				fields.add(field.trim());
			}
			soql = 'SELECT ' + String.join(fields, ',') + ' FROM ' + sObjectType;
			system.debug('soql-->>>> '+soql);
		}
		return Database.query(soql);
	}*/

    @AuraEnabled
    public static List<Sobject> CloneWithChildrenCtrlComponent_Apex(String recordId, String descriptionName){
        List<Sobject> parentObjCloneList = new List<Sobject>();
        try {
            List<ChildObjectWrapper> childObjWrapperList = new List<ChildObjectWrapper>();
            List<ChildObjectWrapper> slctdChildObjWrapperList = new List<ChildObjectWrapper>();
            String parentObjName = CopyQuoteController.getObjectNameFromId(recordId);
            List<Schema.ChildRelationship> childObjList = CopyQuoteController.getChildRelationshipsFromId(recordId);
            for(Schema.ChildRelationship child : childObjList){
                system.debug('child-->>>> '+child);
                system.debug('child.getChildSObject().getDescribe()-->>>> '+child.getChildSObject().getDescribe());
                String customSObjectName = child.getChildSObject().getDescribe().getName();
                if (
                        !customSObjectName.contains('CanaryAMS__Documents__c') &&
                        !customSObjectName.contains('CanaryAMS__Accord_PDF__c') &&
                        !customSObjectName.contains('CanaryAMS__Policy__c') &&
                    	!customSObjectName.contains('OutgoingEmail') &&
                    	!customSObjectName.contains('NetworkUserHistoryRecent') &&
                        child.getField().getDescribe().isCreateable() &&
                        child.getChildSObject().getDescribe().isQueryable()
                ) {
                    childObjWrapperList.add(new ChildObjectWrapper(child.getChildSObject().getDescribe().getName(),true,recordId,String.valueOf(child.getField())));
                }
            }
            CopyQuoteController ccclone = new CopyQuoteController();
            parentObjCloneList = ccclone.cloneWithChildren(childObjWrapperList, parentObjName, recordId, descriptionName);
            system.debug('childObjWrapperList-->>>> '+childObjWrapperList);
        } catch (Exception e) {
            System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method CloneWithChildrenCtrlComponent_Apex  ' + e.getMessage());
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return parentObjCloneList;
    }

    public List<Sobject> cloneWithChildren(List<ChildObjectWrapper> childObjWrapperList,String parentObjName,String recordId, String descriptionName){
        List<ChildObjectWrapper> slctdChildObjWrapperList = new List<ChildObjectWrapper>();
        for(ChildObjectWrapper chldObj : childObjWrapperList){
            if(chldObj.isSelected){
                slctdChildObjWrapperList.add(chldObj);
            }
        }
        Set<Id> allRelatedListIds = new Set<Id>();
        // Clone parent object record first
        List<Sobject> clonedParentObj = CopyQuoteController.cloneObject(parentObjName,recordId,true,null,null, descriptionName);
        insert clonedParentObj;
        // Clone child records
        List<sobject> childObjList = new List<sobject>();
        if(slctdChildObjWrapperList.size() > 0){
            //system.debug('slctdChildObjWrapperList-->>size-->>>>> '+slctdChildObjWrapperList.size());
            for(ChildObjectWrapper obj : slctdChildObjWrapperList){
                //system.debug('obj.recordId-->>>>>> '+obj.recordId);
                List<Sobject> clonedChildObj = CopyQuoteController.cloneObject(obj.objName,obj.recordId,false,obj.relationshipName,clonedParentObj.get(0).Id, null);
                // For Temporary//
                //Set<Id> clonedChildObjIds = CopyQuoteController.getRealtedListIds(obj.objName,obj.recordId,false,obj.relationshipName,clonedParentObj.get(0).Id, null);
                //allRelatedListIds.addAll(clonedChildObjIds);
                // End
                if(clonedChildObj.size() > 0){
                    childObjList.addAll(clonedChildObj);
                }
            }
            //system.debug('allRelatedListIds->>>>>>>> '+allRelatedListIds);
            //system.debug('allRelatedListIds->>>>>>>> '+allRelatedListIds.size());
        }
        Database.insert(childObjList,false);
        system.debug('childObjList->>>> '+childObjList);




        List<SObject> clonedChildObjList = new List<SObject>();
        SObject clonedSobj;
        List<String> childSobjectList = new List<String>();
        for(Sobject chl : childObjList) {
            system.debug('chl00=--<<<>> '+chl);
            String childObjName = String.valueOf(CopyQuoteController.getObjectNameFromId(Id.valueOf(chl.id)));
            system.debug('childObjName=--<<<>> '+childObjName);

             //childSobjectList.add(childObjName);
            /*String childApiName = CopyQuoteController.getChildRelationshipApiName(childObjName);
            system.debug('childApiName-->>>>> '+childApiName);
            String [] apiVsName = childApiName.split(',');
            for(String childObjectName : childSobjectList) {
            // update relationshipField with parentRecordId
            if(String.isNotBlank(childApiName)){
                clonedSobj.put(childApiName,chl.Id);
            }
            clonedChildObjList.add(clonedSobj);

            }*/
        }



        //system.debug('clonedChildObjList->>> '+clonedChildObjList);
        return clonedParentObj;
    }

    public static String getChildRelationshipApiName (String childObjName) {
        String childRelationApiName = '';
        //String childObjName = CopyQuoteController.getObjectNameFromId(childRecordId);
        SObjectType objToken = Schema.getGlobalDescribe().get(childObjName);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap();
        List<String> fieldslist = new List<String>();
        for(String fieldName : fields.keySet()) {
            if(fields.containsKey(fieldName) && fields.get(fieldName).getDescribe().isCreateable()){
                fieldslist.add(fieldName);
                if(String.valueOf(fields.get(fieldName).getDescribe().getType()) == 'REFERENCE'){
                    System.debug('Type >> ' + fieldName); // API name of object in small.
                    System.debug(' objName << ' + childObjName); // parent Object name
                    System.debug(' getName ' + fields.get(fieldName).getDescribe().getName()); // API name lookup object
                    System.debug('getLabel ' + fields.get(fieldName).getDescribe().getLabel()); // label of the object
                    System.debug('sobjectName ' + fields.get(fieldName).getDescribe().getSObjectField());
                    System.debug('sdfasdfa' + fields.get(fieldName).getDescribe());

                    //System.debug('childObjectsNamesListchildObjectsNamesList');
                    //System.debug(childObjectsNamesList);
                    childRelationApiName = fields.get(fieldName).getDescribe().getName() + ',' + fields.get(fieldName).getDescribe().getName();

                }

            }
        }
        return childRelationApiName;
    }

    public static List<Sobject> cloneObject(String objName, Id orgRecordId, Boolean isSelfId,String relationshipField, String parentRecordId, String descriptionName){
        SObjectType objToken = Schema.getGlobalDescribe().get(objName);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap();
        List<String> fieldslist = new List<String>();
        for(String fieldName : fields.keySet()) {
            if(fields.containsKey(fieldName) && fields.get(fieldName).getDescribe().isCreateable()){
                fieldslist.add(fieldName);
            }
        }

        String query;
        if(isSelfId){
            query   = 'SELECT ' + String.join(fieldslist, ',') + ' FROM '+ objName +' WHERE Id =\''+ orgRecordId +'\' LIMIT 1';
        }else{
            query   = 'SELECT ' + String.join(fieldslist, ',') + ' FROM '+ objName +' WHERE '+ relationshipField +' =\''+ orgRecordId +'\'';
        }
        system.debug('query-_>>>>> '+query);
        List<SObject> sObjList = new List<SObject>();
        if(fieldslist.size() > 0){
            sObjList = Database.query(query);
        }
        List<SObject> clonedObjList = new List<SObject>();
        SObject clonedSobj;
        for(Sobject obj : sObjList){
            //system.debug('objIDd---------------->>>>>> '+obj.Id);
            //relatedListIds.add(obj.Id);
            clonedSobj  = obj.clone(false, false, false, false);
            if(!isSelfId && clonedSobj!=null){
                // update relationshipField with parentRecordId
                if(String.isNotBlank(relationshipField) && String.isNotBlank(parentRecordId)){
                    clonedSobj.put(relationshipField,parentRecordId);
                }
            } else {
                if(String.isNotBlank(descriptionName)) {
                    clonedSobj.put('Name', descriptionName);
                }
            }


            clonedObjList.add(clonedSobj);
        }
        //system.debug('relatedListIds-->>>> '+relatedListIds);
        //system.debug('objName-->>>'+objName);
        //system.debug('clonedObjList-->>>>> '+clonedObjList);

        return clonedObjList;
    }
    public static String getObjectNameFromId(Id recordId){
        system.debug('recordId-->> '+recordId);
        Schema.DescribeSObjectResult dr = CopyQuoteController.getDescribeSObjectResultFromId(recordId);
        system.debug('dr.getName()-->>> '+dr.getName());
        return String.valueOf(dr.getName());
    }
    public static List<Schema.ChildRelationship> getChildRelationshipsFromId(Id recordId){
        Schema.DescribeSObjectResult dr = CopyQuoteController.getDescribeSObjectResultFromId(recordId);
        system.debug('dr.getChildRelationships()->>>'+dr.getChildRelationships());
        return dr.getChildRelationships();
    }
    public static Schema.DescribeSObjectResult getDescribeSObjectResultFromId(Id recordId){
        Schema.SObjectType token = recordId.getSObjectType();
        return token.getDescribe();
    }
    public class ChildObjectWrapper{
        public String objName {get;set;}
        public boolean isSelected {get;set;}
        public String recordId {get;set;}
        public String relationshipName {get;set;}
        ChildObjectWrapper(String objName, Boolean isSelected,String recordId, String relationshipName){
            this.objName = objName;
            this.isSelected = isSelected;
            this.recordId = recordId;
            this.relationshipName = relationshipName;
        }
    }
}