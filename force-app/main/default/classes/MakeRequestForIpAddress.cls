public class MakeRequestForIpAddress {
    
    public static String oauthLogin() {
        String loginUri, clientId, clientSecret, username, password, token, getIp='';
        List<credentials__c> credential_list = new List<credentials__c>();
        credential_list = [SELECT Id, Name, Client_Id__c, Client_Secret__c, Password__c, Token__c, User_Name__c FROM credentials__c LIMIT 1];
        if(credential_list.size() > 0) {
            loginUri = 'https://retailshop-dev-ed.my.salesforce.com';
            clientId = credential_list[0].Client_Id__c;
            clientSecret = credential_list[0].Client_Secret__c;
            username = credential_list[0].User_Name__c;
            password = credential_list[0].Password__c;
            token = credential_list[0].Token__c;
            
            String endPoint = loginUri + '/services/oauth2/token?grant_type=password&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password + token;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPoint);
            request.setMethod('POST');
            request.setTimeout(30000);
            HttpResponse response = http.send(request);
            
            System.debug('response : ' + response);
            if (response != NULL && response.getStatusCode() == 200 && !(response.getBody().contains('error'))) {
                String res = response.getBody();
                system.debug('res ' + res);
                
                JSONForIpAddress jsonIp = new JSONForIpAddress();
                jsonIp = (JSONForIpAddress) System.JSON.deserialize(res, JSONForIpAddress.class);
                system.debug('jsonIp >>> ' + jsonIp);
                if (jsonIp.token_type != NULL && jsonIp.access_token != NULL) {
                    getIp = MakeRequestForIpAddress.createLocationStorage_Apex(jsonIp);
                    return getIp;
                } else {
                    system.debug('Token type Or Access token ERROR');
                }
            } else {
                system.debug('NULL IN RESPONSE');
            }
        }
        return null;
    }
    
    public static String createLocationStorage_Apex(JSONForIpAddress obj) {
        if (obj != NULL && obj.token_type != NULL && obj.access_token != NULL) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(obj.instance_url + '/services/apexrest/UserIPAddressDetails');
            request.setMethod('POST');
            request.setHeader('Authorization', obj.token_type + ' ' + obj.access_token);
            request.setHeader('Content-Length', '0');
            request.setHeader('Content-Type', 'application/json');
            request.setBody('');
            request.setTimeout(60000);
            HttpResponse response = http.send(request);
            
            
            if (response != NULL && response.getStatusCode() == 200) {
                system.debug('-<<< ' + response.getBody());
                return response.getBody().replaceAll('"','');
            }
        }
        
        return NULL;
    }
}