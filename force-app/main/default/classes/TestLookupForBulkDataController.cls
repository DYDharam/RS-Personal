@isTest
public class TestLookupForBulkDataController {
	@isTest
    public static void getContact_ApexTest() {
        test.startTest();
        lookupForBulkDataController.getContact_Apex();
        test.stopTest();
    }
    @isTest
    public static void getSobjectRecord_ApexTest() {
        test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        lookupForBulkDataController.getSobjectRecord_Apex('Account', acc.Id);
        test.stopTest();
    }
    @isTest
    public static void fetchLookUpValuesTest() {
        test.startTest();
        lookupForBulkDataController.fetchLookUpValues('Test Account', 'Account');
        test.stopTest();
    }
}