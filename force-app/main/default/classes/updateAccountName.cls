public class updateAccountName {
    @AuraEnabled
    public static List<wrapAccountNContactsize> getDetails_Apex() {
        List<wrapAccountNContactsize> wrapList = new List<wrapAccountNContactsize>();
        List<Account> accounts = [SELECT Id, Name, (SELECT id FROM Contacts) FROM Account LIMIT 5];
        for (Account a : accounts) {
            wrapAccountNContactsize wrap = new wrapAccountNContactsize();
            System.debug('Count of Contacts is ' + a.Contacts.size());
            wrap.accName = a.Name;
            wrap.totalContact = a.Contacts.size();
            wrapList.add(wrap);
        }
        return wrapList;
    }
    public class wrapAccountNContactsize {
        @AuraEnabled
        public String accName {set; get;}
        @AuraEnabled
        public Integer totalContact {set; get;}
    }
}