global class lookUpAccountAnnotation {
    @InvocableMethod
    public static List<Account> getAccountIds(List<String> names) {
        List<Id> accountIds = new List<Id>();
        List<Account> accounts = [SELECT Id FROM Account WHERE Name =: names];
        for (Account account : accounts) {
            account.Type = 'Prospect';
        }
        update accounts;
        return accounts;
    }
}