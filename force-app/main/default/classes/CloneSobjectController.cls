public class CloneSobjectController {
    @AuraEnabled
    public static String getCloneWithChildrenCtrl_Apex (String recordId){
        List<ChildObjectWrapper> childObjWrapperList = new List<ChildObjectWrapper>();
        List<ChildObjectWrapper> slctdChildObjWrapperList = new List<ChildObjectWrapper>();
        String parentObjName = UtilityClass.getObjectNameFromId(recordId);
        system.debug('parentObjName-->>> '+parentObjName);
        List<Schema.ChildRelationship> childObjList = UtilityClass.getChildRelationshipsFromId(recordId);
        system.debug('childObjList->>>>>>>> '+childObjList);
        for(Schema.ChildRelationship child : childObjList){
            if(child.getChildSObject().getDescribe().isQueryable()){
                if(child.getField().getDescribe().isCreateable()) {
                    System.debug('child.getChildSObject().getDescribe().getName()----->>>> '+child.getChildSObject().getDescribe().getName());
                    System.debug('recordId--->> '+recordId);
                    system.debug('child.getField()-->>> '+child.getField());
                    String childName = String.valueOf(child.getField());
                    if(childName.contains('__c')) {
                        childObjWrapperList.add(new ChildObjectWrapper(child.getChildSObject().getDescribe().getName(),true,recordId,String.valueOf(child.getField())));
                    }
                }
            }
        }
        /*for(ChildObjectWrapper chldObj : childObjWrapperList){
            chldObj.isSelected = true;
        }*/
        CloneSobjectController ctrl = new CloneSobjectController();
        ctrl.cloneWithChildren(childObjWrapperList, recordId, parentObjName);
        system.debug('childObjWrapperList->>>>>>>>'+childObjWrapperList);
        return 'done';
    }
    public void cloneWithChildren(List<ChildObjectWrapper> childObjWrapperList, String recordId, String parentObjName){
        List<ChildObjectWrapper> slctdChildObjWrapperList = new List<ChildObjectWrapper>();
        for(ChildObjectWrapper chldObj : childObjWrapperList){
            if(chldObj.isSelected){
                slctdChildObjWrapperList.add(chldObj);
            }
        }
        system.debug('slctdChildObjWrapperList--<<<< '+slctdChildObjWrapperList);
        // Clone parent object record first
        List<Sobject> clonedParentObj = UtilityClass.cloneObject(parentObjName,recordId,true,null,null);
        insert clonedParentObj;
        system.debug('clonedParentObj->>>>>>>> '+clonedParentObj);
        // Clone child records
        List<sobject> childObjList = new List<sobject>();
        if(slctdChildObjWrapperList.size() > 0){
            for(ChildObjectWrapper obj : slctdChildObjWrapperList){
                List<Sobject> clonedChildObj = UtilityClass.cloneObject(obj.objName,obj.recordId,false,obj.relationshipName,clonedParentObj.get(0).Id);
                if(clonedChildObj.size() > 0){
                    childObjList.addAll(clonedChildObj);
                }
            }
            system.debug('childObjList->>> '+childObjList);
        }
        Database.insert(childObjList,false);
        system.debug('childObjList22222->>> '+childObjList);
        //return new PageReference('/'+clonedParentObj.get(0).Id);
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