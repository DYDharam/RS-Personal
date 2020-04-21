public class UserLoginController {
	@AuraEnabled
    public static list<Customer__c> GetUserIdAndCheckForNewUserOrNot (String UserId)
	{
		list<Customer__c> cus_list = new list<Customer__c>();
        cus_list = [Select Id, Name, Email__c, Password__c from Customer__c WHERE Id =: UserId LIMIT 1];
        if(cus_list.size() > 0)
        {
        	return cus_list;
        }
        else
        {
            return null;
        }
        return cus_list;
	}
    @AuraEnabled
    public static list<Attachment> GetAttachmentOfUserLogin (String UserParentId)
	{
		list<Attachment> attlist = new list<Attachment>();
        attlist = [select Id, Name, ParentId from Attachment where ParentId =: UserParentId];
        system.debug('attlist----->'+attlist);
        if(attlist.size() > 0)
        {
        	return attlist;
        }
        else
        {
            return null;
        }
        return attlist;
	}
    @AuraEnabled
    public static list<Customer__c> FirstTimeUserInsertEmail_Apex (String userId, String userEmail, String userPassword)
    {
        list<Customer__c> cus_list = new list<Customer__c> ();
        list<Customer__c> cus_listUpdate = new list<Customer__c> ();
        cus_list = [select Id, Name, Email__c, Password__c from Customer__c WHERE Id =: userId LIMIT 1];
        
        Customer__c cus = new Customer__c();
        cus.Id = userId;
        cus.Email__c = userEmail;
        cus.Password__c = userPassword;
        cus_listUpdate.add(cus);
        if(cus_listUpdate.size()>0)
        {
            update cus_listUpdate;
            return cus_listUpdate;
        }
        return null;
    }
}