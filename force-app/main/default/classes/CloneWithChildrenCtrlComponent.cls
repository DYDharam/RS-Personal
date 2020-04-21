public class CloneWithChildrenCtrlComponent {
    
    // Id of parent object which needs to be cloned
    private Id recordId {get;set;}
    
    // Name of the parent object which needs to be cloned
    public String parentObjName {get;set;}
    
    // List of wrapper object (child records) which needs to be displayed on page
    public List<ChildObjectWrapper> childObjWrapperList {get;set;}
    
    // List of selected wrapper object (child records) which needs to be passed to controller
    public List<ChildObjectWrapper> slctdChildObjWrapperList {get;set;}
    
    /** Method name : CloneWithChildrenCtrl
     * Arguments : NA
     * Return type : NA - Constructor
     * Description : Fetches the record id which is passed as a url parameter and creates a list of wrapper object which is displayed on page 
    **/
    @AuraEnabled
    public static String cloneData_Apex(String recordId) {
        CloneWithChildrenCtrlComponent onsdf = new CloneWithChildrenCtrlComponent();
        recordId = recordId;
        return null;
    }
    @AuraEnabled
    public static void CloneWithChildrenCtrlComponent_Apex(String recordId){
        List<ChildObjectWrapper> childObjWrapperList = new List<ChildObjectWrapper>();
        List<ChildObjectWrapper> slctdChildObjWrapperList = new List<ChildObjectWrapper>();
        //recordId = ApexPages.currentPage().getParameters().get('Id');
        String parentObjName = UtilityClass.getObjectNameFromId(recordId);
        List<Schema.ChildRelationship> childObjList = UtilityClass.getChildRelationshipsFromId(recordId);
        for(Schema.ChildRelationship child : childObjList){
            if(child.getChildSObject().getDescribe().isQueryable()){
                if(child.getField().getDescribe().isCreateable())
                    childObjWrapperList.add(new ChildObjectWrapper(child.getChildSObject().getDescribe().getName(),true,recordId,String.valueOf(child.getField())));
            }
        }
        CloneWithChildrenCtrlComponent ccclone = new CloneWithChildrenCtrlComponent();
        ccclone.cloneWithChildren(childObjWrapperList, parentObjName, recordId);
    }
    
    /** Wrapper class - Holds the value of associated child records with a checkbox **/
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
    
    /** Method name : cancel
     * Arguments : NA
     * Return type : PageReference
     * Description : Called on click of cancel button, redirects the user back to record detail page 
    **/
    public PageReference cancel(){
        return new PageReference('/'+recordId);
    }
    
    /** Method name : cloneWithChildren
     * Arguments : NA
     * Return type : PageReference
     * Description : Called on click of Clone button, clones parent and selected child records and redirects user to new parent record
     * detail page. 
    **/
    public PageReference cloneWithChildren(List<ChildObjectWrapper> childObjWrapperList,String parentObjName,String recordId){
        List<ChildObjectWrapper> slctdChildObjWrapperList = new List<ChildObjectWrapper>();
        for(ChildObjectWrapper chldObj : childObjWrapperList){
            if(chldObj.isSelected){
                slctdChildObjWrapperList.add(chldObj);
            }
        }
        // Clone parent object record first
        List<Sobject> clonedParentObj = UtilityClass.cloneObject(parentObjName,recordId,true,null,null);
        insert clonedParentObj;
        // Clone child records
        List<sobject> childObjList = new List<sobject>();
        if(slctdChildObjWrapperList.size() > 0){
            for(ChildObjectWrapper obj : slctdChildObjWrapperList){
                if(obj.objName != 'OutgoingEmail') {
                    List<Sobject> clonedChildObj = UtilityClass.cloneObject(obj.objName,obj.recordId,false,obj.relationshipName,clonedParentObj.get(0).Id);
                    if(clonedChildObj.size() > 0){
                        childObjList.addAll(clonedChildObj);
                    }
                }
                
            }
        }
        Database.insert(childObjList,false);
        return new PageReference('/'+clonedParentObj.get(0).Id);
    }
    
    /** Method name : checkAll
     * Arguments : NA
     * Return type : PageReference
     * Description : Called when CheckAll checkbox is checked
    **/
    public PageReference checkAll(){
        for(ChildObjectWrapper chldObj : childObjWrapperList){
            chldObj.isSelected = true;
        }
        return null;
    }
    
}