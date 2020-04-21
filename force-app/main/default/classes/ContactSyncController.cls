public class ContactSyncController {
    //private static final String CLIENT_ID = '973024471876-0fc8u6kstvdrcjeo50vedvj18g5ppapb.apps.googleusercontent.com';
    //private static final String CLIENT_SECRET = 'AqC37L8q4GfbVS31RF893qV4';
    private static final String OAUTH_URL = 'https://accounts.google.com/o/oauth2/auth?';
    private static final String TOKEN_URL = 'https://accounts.google.com/o/oauth2/token';
    private static final String GET_CONTACTS_URL = 'https://people.googleapis.com/v1/people/me/connections';
    private static final String SCOPE = 'https://www.googleapis.com/auth/contacts https://www.googleapis.com/auth/contacts.readonly https://www.googleapis.com/auth/plus.login';
    private static final String REDIRECT_URI = 'https://retailshop-dev-ed--c.ap5.visual.force.com/apex/ContactSyncPage';
    private static final String STATE = 'ContactSyncApp';
    
    @AuraEnabled
    public static String accessToken_Apex(String code) {
        try {
            Google_Contact__c gcT = Google_Contact__c.getall().values();
            String CLIENT_SECRET = gcT.client_secret__c;
            String CLIENT_ID = gcT.client_id__c;
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            String endpoint = 'code=' + code + '&redirect_uri=' + EncodingUtil.urlEncode(REDIRECT_URI, 'UTF-8')
                + '&client_id=' + EncodingUtil.urlEncode(CLIENT_ID, 'UTF-8') + '&client_secret=' + EncodingUtil.urlEncode(CLIENT_SECRET, 'UTF-8')
                + '&grant_type=authorization_code';
            System.debug(LoggingLevel.ERROR, TOKEN_URL + endpoint);
            request.setEndpoint(TOKEN_URL);
            request.setBody(endpoint);
            request.setHeader('Content-length', String.valueOf(endpoint.length()));
            request.setTimeout(120000);
            System.debug(LoggingLevel.ERROR, request);
            response = http.send(request);
            System.debug(LoggingLevel.ERROR, response.getBody());
            return response.getBody();
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, ex.getMessage() + '--' + ex.getLineNumber());
            return null;
        }
    }
    @AuraEnabled
    public static String getOAuthURL() {
        Google_Contact__c gcT = Google_Contact__c.getall().values();
        String CLIENT_ID = gcT.client_id__c;
        
        String oauthValue = OAUTH_URL + 'scope=' + EncodingUtil.urlEncode(SCOPE, 'UTF-8') + '&access_type=offline&state=' + STATE
            + '&redirect_uri=' + EncodingUtil.urlEncode(REDIRECT_URI, 'UTF-8') + '&response_type=code&client_id=' + CLIENT_ID;
        return oauthValue;
    }
}