/*
* Created by:	Dharmendra Kumar on 18 April 2020.
* Purpose:		To cover the test class and the class name is 'CreateSObjectDynamicallyCtrl'.
*/
@isTest
public class Test_CreateSObjectDynamicallyCtrl {
    public static Account createAccountRecord(Boolean isInsert){
        Account accountObject = new Account();
        accountObject.Name = 'Test Account - 01';
        if(isInsert) {
            insert accountObject;
        }
        return accountObject;
    }
    @isTest static void Test_getAllFields_Apex() {
        test.startTest();
        Account accountObject = createAccountRecord(true);
        List<CreateSObjectDynamicallyCtrl.wrapperOfSObjectDetails> wrapperOfSObjectList = CreateSObjectDynamicallyCtrl.getAllFields_Apex('Account', accountObject.Id);
        System.assertNotEquals(wrapperOfSObjectList.size(), 0);
        test.stopTest();
    }
    @isTest static void Test_getPickListValues() {
        test.startTest();
        List<CreateSObjectDynamicallyCtrl.wrapSelectFromPickList> pickListValue = CreateSObjectDynamicallyCtrl.getPickListValues('UpsellOpportunity__c', 'Account');
        System.assertNotEquals(pickListValue.size(), 0);
        test.stopTest();
    }
    @isTest static void Test_getObjectFields() {
        test.startTest();
        List<String> fieldsList = CreateSObjectDynamicallyCtrl.getObjectFields('Account');
        System.assertNotEquals(fieldsList.size(), 0);
        test.stopTest();
    }
    @isTest static void Test_getFieldType() {
        test.startTest();
        String fieldType = CreateSObjectDynamicallyCtrl.getFieldType('Account', 'Name');
        fieldType = fieldType.toLowerCase();
        System.assertEquals(fieldType, 'string');
        test.stopTest();
    }
    @isTest static void Test_getAllFields_Apex_Copy() {
        test.startTest();
        Account accountObject = createAccountRecord(true);
        List<CreateSObjectDynamicallyCtrl.wrapperOfSObjectDetails> wrapperOfSObjectList = CreateSObjectDynamicallyCtrl.getAllFields_Apex_Copy('Account', accountObject.Id, '');
        System.assertNotEquals(wrapperOfSObjectList.size(), 0);
        test.stopTest();
    }
    @isTest static void Test_getAllFields() {
        test.startTest();
        Account accountObject = createAccountRecord(true);
        List<String> fieldsList = CreateSObjectDynamicallyCtrl.getAllFields('Account', accountObject.Id);
        System.assertNotEquals(fieldsList.size(), 0);
        test.stopTest();
    }
    @isTest static void Test_saveSobjectRecord_Apex() {
        test.startTest();
        Account accountObject = createAccountRecord(false);
        List<sObject> objectList = CreateSObjectDynamicallyCtrl.saveSobjectRecord_Apex('[{"Name":"Tstest"}]', 'List<Account>');
        System.assertEquals(objectList.size(), 1);
        test.stopTest();
    }
    
}