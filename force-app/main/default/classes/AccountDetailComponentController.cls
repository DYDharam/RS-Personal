public with sharing class AccountDetailComponentController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [SELECT Id, Name, CreatedDate, NumberOfEmployees, CleanStatus, Phone, AnnualRevenue FROM Account LIMIT 50];
    }
    @AuraEnabled
    public static String deleteContacts(list<Id> listAccountIds){
        String message = 'error';
        try {
            list<Account> lstAccountToDelete = new list<Account>();
            System.debug('listAccountIds ====> '+listAccountIds);
            for(Id idAcc : listAccountIds) {
                lstAccountToDelete.add(new Account(Id = idAcc));
            }
            if(!lstAccountToDelete.isEmpty()) {
                delete lstAccountToDelete;
            }
            message = 'success';
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return message;
    }
    @AuraEnabled
    public static List<Contact> findAllContactsRelatedToAccounts (List<Account> getAllAccountsDetails) {
        List<Contact> contactList = new List<Contact>();
        contactList = [SELECT Id, Name, CreatedDate FROM Contact WHERE AccountId IN: getAllAccountsDetails];
        return contactList;
    }
}