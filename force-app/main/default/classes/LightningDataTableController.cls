public class LightningDataTableController {
    
    
    @AuraEnabled
    public static List < Account > fetchAccts(Integer intOffSet) {
        
        return [ SELECT Id, Name, Industry, Type, IsCustomerPortal FROM Account LIMIT 5 OFFSET : Integer.valueOf(intOffSet) ];
        
    }
    
    //Get SObject List
    @AuraEnabled
    public static List<SObject> getSobjectList(Integer recordLimit, Integer recordOffset, String sObjectName){
        Integer intLimit = Integer.valueof(recordLimit);
        Integer intOffset = Integer.valueof(recordOffset);
        List<SObject> sObjectList = new List<SObject>();
        String stringQuery = 'SELECT Id, Name, Email, Phone, DoNotCall, Active_Customer__c FROM '+ sObjectName +' LIMIT :intLimit Offset :intOffset';
        sObjectList = Database.query(stringQuery);
        return sObjectList;
    }
     
    //Get Total Number of Sobject
    @AuraEnabled
    public static Integer getTotalSobjectRecords(String sObjectName){
        Integer totalRecords = database.countQuery('select count() from ' + sObjectName + '');
        return totalRecords;
    } 
     
    //Delete Contact
    @AuraEnabled
    public static void deleteContact(Contact con){
        Delete con;
    } 
}