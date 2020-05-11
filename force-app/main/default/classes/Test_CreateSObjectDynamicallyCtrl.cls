/*
* Created by:	Dharmendra Kumar on 18 April 2020.
* Purpose:		To cover the test class and the class name is 'CreateSObjectDynamicallyCtrl'.
*/
@isTest
public class Test_CreateSObjectDynamicallyCtrl {
    /*
     * Other Way to cover. Example here. 
    @testSetup
    static void test_Scenario1(){
        Test.startTest();
        Account accountObject = new Account();
        accountObject.Name = 'Test Account - 02';
        insert accountObject;
        Test.stopTest();
    }
    
    static TestMethod void test_Scenario2(){
        Test.startTest();
        Account accountObject = [Select Id, Name From Account Where Name = 'Test Account - 02' Limit 1];
        List<CreateSObjectDynamicallyCtrl.wrapperOfSObjectDetails> wrapperOfSObjectList = CreateSObjectDynamicallyCtrl.getAllFields_Apex('Account', accountObject.Id);
        System.assertNotEquals(wrapperOfSObjectList.size(), 0);
        Test.stopTest();
    }*/
    
    /*static TestMethod void test_Scenario3(){
        Test.startTest();
        User usr = [Select Id From User Where Id = :UserInfo.getUserId()];
        System.runAs(usr){
            // To run As Current User.
        }
        Test.stopTest();
    }*/
    
    public static List<Account> createAccountRecord(Boolean isInsert, Integer noOfRecords){
        List<Account> accountList = new List<Account>();
        for(Integer i = 0; i < noOfRecords; i++) {
            Account accountObject = new Account();
            accountObject.Name = 'Test Account - 01';
            accountList.add(accountObject);
        }
        if(isInsert) {
            insert accountList;
        }
        return accountList;
    }
    @isTest static void Test_getSobjectList_Apex() {
        test.startTest();
        List<CreateSObjectDynamicallyCtrl.sobjectListNameNApi> sobjectPickList = CreateSObjectDynamicallyCtrl.getSobjectList_Apex();
        System.assertNotEquals(sobjectPickList.size(), 0);
        test.stopTest();
    }
    @isTest static void Test_getAllFields_Apex() {
        test.startTest();
        List<Account> accountList = createAccountRecord(true, 200);
        List<CreateSObjectDynamicallyCtrl.wrapperOfSObjectDetails> wrapperOfSObjectList = CreateSObjectDynamicallyCtrl.getAllFields_Apex('Account', accountList[0].Id);
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
        List<Account> accountList = createAccountRecord(true, 200);
        List<CreateSObjectDynamicallyCtrl.wrapperOfSObjectDetails> wrapperOfSObjectList = CreateSObjectDynamicallyCtrl.getAllFields_Apex_Copy('Account', accountList[0].Id, '');
        System.assertNotEquals(wrapperOfSObjectList.size(), 0);
        List<CreateSObjectDynamicallyCtrl.wrapperOfSObjectDetails> wrapperOfSObjectList2 = CreateSObjectDynamicallyCtrl.getAllFields_Apex_Copy('Account', accountList[0].Id, 'Account-Account Layout');
        System.assertNotEquals(wrapperOfSObjectList2.size(), 0);
        test.stopTest();
    }
    @isTest static void Test_getAllFieldsLWC_Apex() {
        test.startTest();
        List<Account> accountList = createAccountRecord(true, 200);
        List<CreateSObjectDynamicallyCtrl.wrapperOfSObjectLWCDetails> wrapperOfSObjectList = CreateSObjectDynamicallyCtrl.getAllFieldsLWC_Apex('Account', accountList[0].Id);
        System.assertNotEquals(wrapperOfSObjectList.size(), 0);
        test.stopTest();
    }
    @isTest static void Test_saveSobjectRecord_Apex() {
        test.startTest();
        //List<Account> accountList = createAccountRecord(false, 200);
        List<sObject> objectList = CreateSObjectDynamicallyCtrl.saveSobjectRecord_Apex('[{"Name":"Tstest"}]', 'List<Account>');
        System.assertEquals(objectList.size(), 1);
        test.stopTest();
    } 
}