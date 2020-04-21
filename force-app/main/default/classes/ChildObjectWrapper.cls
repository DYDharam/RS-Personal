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