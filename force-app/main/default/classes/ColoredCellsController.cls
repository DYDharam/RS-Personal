public class ColoredCellsController {
    
   	
    @AuraEnabled
    public static List<customWrapper> getRecord_apex() {
        List<customWrapper> wrapList = new List<customWrapper>();
        try{
            List<Account> accountList = new List<Account>();
            accountList = [SELECT Id, Name, OwnerId, Owner.name, CreatedDate, NumberOfEmployees, CleanStatus, Phone, AnnualRevenue FROM Account LIMIT 50];
            Integer count = 0;
            for(Account account : accountList) {
                count++;
                customWrapper wrap = new customWrapper();
                wrap.Name = account.Name;
                if(account.NumberOfEmployees >= 90) {
                    wrap.NumberOfEmployeesClass = 'bgBlue';
                } else if(account.NumberOfEmployees > 33 && account.NumberOfEmployees < 90) {
                    wrap.NumberOfEmployeesClass = 'bgGreen';
                } else {
                    wrap.NumberOfEmployeesClass = 'bgRed';
                }
                wrap.NumberOfEmployees = account.NumberOfEmployees;
                wrap.CleanStatus = account.CleanStatus;
                wrap.Mobile = account.Phone;
                wrap.AnnualRevenue = account.AnnualRevenue;
                if(math.mod(count, 2) == 0) {
                    wrap.Working = true;
                    wrap.isShow = 'slds-hide';
                } else {
                    wrap.Working = false;
                    wrap.isShow = 'slds-show';
                }
                wrap.linkName = 'https://retailshop-dev-ed.my.salesforce.com/' + account.Id;
                wrap.CreatedDate = Date.valueOf(account.CreatedDate);
                wrapList.add(wrap);
                system.debug('wrapList-->> ' + wrapList);
            }
        } catch(Exception ex) {
            system.debug('Error Message ::: ' + ex.getMessage() + ' Due to this issues ::: ' + ex.getLineNumber());
        }
        return wrapList;
    }
    public class customWrapper{
        @AuraEnabled
        public String Name {set; get;}
        @AuraEnabled
        public Integer NumberOfEmployees {set; get;}
        @AuraEnabled
        public String NumberOfEmployeesClass {set; get;}
        @AuraEnabled
        public String CleanStatus {set; get;}
        @AuraEnabled
        public String Mobile {set; get;}
        @AuraEnabled
        public Decimal AnnualRevenue {set; get;}
        @AuraEnabled
        public Boolean Working {set; get;}
        @AuraEnabled
        public Date CreatedDate {set; get;}
        @AuraEnabled
        public String isShow {set; get;}
        @AuraEnabled
        public String linkName {set; get;}
    }
}