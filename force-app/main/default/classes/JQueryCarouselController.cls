public class JQueryCarouselController {
    @AuraEnabled
    Public static List<Account> Accdata(){
        List<Account> alist=[Select Name,Billingcity,Type,BillingState from Account order by createddate];
        if(alist.size() > 0)
        {
            return alist;
        }
        return null;
    }
}