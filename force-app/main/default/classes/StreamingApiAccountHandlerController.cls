public class StreamingApiAccountHandlerController {
	/**
     * This method returns signed in user's session id
     * @author DY
     * */
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }
    @AuraEnabled
    public static Boolean updateAccountPhone_Apex() {
        Account accountObject = [SELECT Id, Name, Phone, ShippingState, BillingState FROM Account WHERE Id = '0017F00000NW6m2QAD' LIMIT 1];
        if(accountObject.Phone == '98765432321') {
            accountObject.Phone = '98765432320';
            accountObject.ShippingState = 'United Sate';
            accountObject.BillingState = 'United Sate';
        } else {
            accountObject.Phone = '98765432321';
            accountObject.ShippingState = 'United Kingdom';
            accountObject.BillingState = 'United Kingdom';
        }
        if(accountObject.Id != null) {
            update accountObject;
            return true;
        }
        return false;
    }
}