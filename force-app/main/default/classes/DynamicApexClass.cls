public class DynamicApexClass {
    /*
     * Get related list from parent Object name.
     */
    public static map<string,string> getRelatedObjects(string masterObjectName){
        map<string,string> relatedObjectsMap = new map<string,string>();
        list<Schema.Childrelationship> relatedObjectsList = Schema.getGlobalDescribe().get(masterObjectName).getdescribe().getChildRelationships();
        for (Schema.Childrelationship  relatedObject : relatedObjectsList) {
            if(relatedObject.getChildSObject().getDescribe().isUpdateable()
               && 
               relatedObject.getChildSObject().getDescribe().getKeyPrefix()!=null
               && 
               !relatedObject.getChildSObject().getDescribe().isCustomSetting()
               &&
               relatedObject.getChildSObject().getDescribe().isCreateable()
              )
                relatedObjectsMap.put(relatedObject.getChildSObject().getDescribe().getName(),relatedObject.getChildSObject().getDescribe().getLabel());
        }
        system.debug('relatedObjectsMap ::::: ' + relatedObjectsMap);
        return relatedObjectsMap;
    }
}