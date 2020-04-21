public class UtilityClass {
    
    /** Method name : getObjectNameFromId
     * Arguments : Id recordId - the id of the record whose name needs to be identified
     * Return type : String
     * Description : Pass the record id to this method and it will return you the name of associated object
    **/
    public static String getObjectNameFromId(Id recordId){
        Schema.DescribeSObjectResult dr = UtilityHelper.getDescribeSObjectResultFromId(recordId);
        return dr.getName(); 
    }
    
    /** Method name : getChildRelationshipsFromId
     * Arguments : Id recordId - the id of the record whose name child relationships needs to be identified
     * Return type : List<Schema.ChildRelationship>
     * Description : Pass the record id to this method and it will return you a list of all associated child relationships
    **/
    public static List<Schema.ChildRelationship> getChildRelationshipsFromId(Id recordId){
        Schema.DescribeSObjectResult dr = UtilityHelper.getDescribeSObjectResultFromId(recordId);
        system.debug('dr.getChildRelationships()->>>'+dr.getChildRelationships());
        return dr.getChildRelationships();
    }
    
    /** Method name : cloneObject
     * Arguments : String objName : Name of the object which needs to be cloned
     * Id orgRecordId : Id of the parent record on which clone button is created
     * Boolean isSelfId : Boolean flag to determine whether the agrument orgRecordId is self id or parent object id
     * String relationshipField : Used when the orgRecordId is parent id
     * String parentRecordId : Id of parent record
     * Return type : List<Sobject> - List of object which is cloned
     * Description : Clones the parent or related list record based on the parameters passed
    **/
    public static List<Sobject> cloneObject(String objName, Id orgRecordId, Boolean isSelfId,String relationshipField, String parentRecordId){
        SObjectType objToken = Schema.getGlobalDescribe().get(objName);
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap();
        List<String> fieldslist = new List<String>();
        for(String fieldName : fields.keySet()) {
            if(fields.containsKey(fieldName) && fields.get(fieldName).getDescribe().isCreateable()){
                fieldslist.add(fieldName);
            }
        }
        
        /*Add exceptional condition for OpportunityLineItem object as we cannot specify Total price and Unit price together for an 
        OpportunityLineItem record */
        if(objName.equals('OpportunityLineItem')){
            // Convert List to Set as List does not have contains method
            Set<String> fieldsSet = new Set<String>(fieldslist);
            if(fieldsSet.contains('unitprice') && fieldsSet.contains('totalprice')){
                // remove either TotalPrice or UnitPrice
                fieldsSet.remove('totalprice');
                fieldslist.clear();
                fieldslist.addAll(fieldsSet);
            }
        }
        
        String query;
        system.debug('isSelfId-->>>>>>'+isSelfId);
        if(isSelfId){
            query   = 'SELECT ' + String.join(fieldslist, ',') + ' FROM '+ objName +' WHERE Id =\''+ orgRecordId +'\' LIMIT 1';
        }else{
            query   = 'SELECT ' + String.join(fieldslist, ',') + ' FROM '+ objName +' WHERE '+ relationshipField +' =\''+ orgRecordId +'\'';
        }
        List<SObject> sObjList = new List<SObject>();
        if(fieldslist.size() > 0){
            sObjList = Database.query(query); 
        }
        List<SObject> clonedObjList = new List<SObject>();
        SObject clonedSobj;
        for(Sobject obj : sObjList){
            system.debug('clonedS obj-->>>'+obj);
            if(objName == 'Account') {
                system.debug('clonedS obj ACCOUNT-->>>'+obj);
            }
            clonedSobj  = obj.clone(false, false, false, false);
            system.debug('clonedSobj-->>>>>>'+clonedSobj);
            if(!isSelfId && clonedSobj!=null){
                // update relationshipField with parentRecordId
                if(String.isNotBlank(relationshipField) && String.isNotBlank(parentRecordId)){
                    clonedSobj.put(relationshipField,parentRecordId);
                }
            } else {
                String sname = String.valueOf(clonedSobj.get('Name'));
                sname += ' CLONED HERE ';
                system.debug('sname-->>>>>>>>>>> '+sname);
                clonedSobj.put('Name', sname);
            }
            
            
            clonedObjList.add(clonedSobj);
        }
        system.debug('objName-->>>'+objName);
        system.debug('clonedObjList-->>>>> '+clonedObjList);
        
        return clonedObjList;
    }
    public static List<String> objectNameList(Boolean isStandard, Boolean isCustom, Boolean isLabel){
        List<String> objectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            if(isCustom ) {
                if(objTyp.getDescribe().isCustom()){
                    if(isLabel) {
                        objectList.add(objTyp.getDescribe().getLabel());
                    } else {
                        objectList.add(objTyp.getDescribe().getName());
                    }
                    //objectSet.add(new objectClass(objTyp.getDescribe().getLabel(), objTyp.getDescribe().getName(), objTyp.getDescribe().getKeyPrefix(), objTyp.getDescribe().getChildRelationships(), objTyp.getDescribe().isCustomSetting(), objTyp.getDescribe().getRecordTypeInfos()));
                }
            } else if(isStandard ) {
                if(!objTyp.getDescribe().isCustom()){
                    if(isLabel) {
                        objectList.add(objTyp.getDescribe().getLabel());
                    } else {
                        objectList.add(objTyp.getDescribe().getName());
                    }
                }
            } else if(isStandard && isCustom) {
                if(isLabel) {
                    objectList.add(objTyp.getDescribe().getLabel());
                } else {
                    objectList.add(objTyp.getDescribe().getName());
                }
            }
        }
        return objectList;
    }
    // To get the icon of the object.
    @AuraEnabled
    public static String getIconName(String sObjectName){
        String u;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();

        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }

        for(Schema.DescribeTabResult tr : tabDesc) {
            if( sObjectName == tr.getSobjectName() ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    u = 'standard:' + sObjectName.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }
        system.debug('u::: ' + u);
        return u;
    }
}