public class GoogleDriveController{
    //Fetched from URL
    private String code ;
    public blob file { get; set; }
   // public String type{get; set;}
    public String filetype{get;set;}
    public  String filename{get; set;}

    private string key = '60690235412-6dvdp6tmm79siggsfri48otdr1tb5dfl.apps.googleusercontent.com' ;
    private string secret = 'Fr-8IWF7tCSELF9lGTsw9Ni_' ;
    private string redirect_uri = 'https://retailshop-dev-ed--c.ap5.visual.force.com/apex/GoogleDrive' ;
    private String accesstoken ;
    private  Integer expiresIn ;
    private String tokentype;

    public GoogleDriveController()
    {
        code = ApexPages.currentPage().getParameters().get('code') ;
        System.debug('----------------------------------------------------------------'+code);
        //Get the access token once we have code
        if(code != '' && code != null)
        {
            AccessToken() ;
        }
    }

    public PageReference DriveAuth()
    {
        //Authenticating
        PageReference pg = new PageReference(GoogleDriveAuthUri (key , redirect_uri)) ;
        return pg ;
    }

    public String GoogleDriveAuthUri(String Clientkey,String redirect_uri)
    {
        String key = EncodingUtil.urlEncode(Clientkey,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
        'client_id='+key+
        '&response_type=code'+
        '&scope=https://www.googleapis.com/auth/drive'+
        '&redirect_uri='+uri+
        '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
        '&login_hint=jsmith@example.com&'+
        'access_type=offline';
        return authuri;
    }
    public  PageReference UploadFile()
    {


      System.debug('----------------fn---------------'+filename);
      //System.debug('----------------ft---------------'+filetype);
      System.debug('------------------at-------------'+accessToken);
       //String parent_id = '1121945745';
        String boundary = '-------314159265358979323846';
        String delimiter = '\r\n--' + boundary +'\r\n';
        String close_delim = '\r\n--' + boundary + '--';
        String bodyEncoded = EncodingUtil.base64Encode(file);
       System.debug('--------------be-----------------'+bodyEncoded);

        String body=
        delimiter +
       'Content-Type: application/json\r\n\r\n' + 
       '{ "title" : "'+ filename+'",' +
        ' "mimeType" : "'+ filetype+ '" }'  + 
        delimiter +
       'Content-Type: ' + filetype + '\r\n' +
       'Content-Transfer-Encoding: base64\r\n' +
       '\r\n' +
        bodyEncoded +
        close_delim;

        System.debug('--------body is-------------'+body);




    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://www.googleapis.com/upload/drive/v2/files');

    req.setHeader('Authorization', 'Bearer' +accessToken);
    req.setHeader('Content-Type', 'multipart/mixed; boundary="'+boundary+'"'); 
    req.setHeader('Content-length', String.valueOf(body.length()));
    req.setHeader('Content-Encoding','base64');
    req.setBody(body);
    req.setMethod('POST');
    req.setTimeout(60*1000);
    // Http http = new Http();
    // HTTPResponse res = http.send(req);
     HttpResponse res = null;
     http h= new Http();
     res= h.send(req);
     System.debug('---------------------'+res.getbody());
     return null;

    //string sUrl = 'https://accounts.google.com';
    //req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
    // req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
    // req.setHeader('Content-Length',String.valueof(body.length()));
    //req.setTimeout(60000); 
    //  req.setHeader('Content-Encoding','base64');
    }

    public void AccessToken()
    {
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+code+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';

        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);


        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();




        JSONParser parser = JSON.createParser(resp);
        while (parser.nextToken() != null) {
        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
        String fieldName = parser.getText();
        parser.nextToken();
        if(fieldName == 'access_token')
        {
            accesstoken = parser.getText();
        } 
        else if(fieldName == 'expires_in')
        {
            expiresIn = parser.getIntegerValue();
        }
        else if(fieldname=='token_type')
        {
            tokentype=parser.getText();
        }
        }
  }   
        System.debug(' You can parse the response to get the access token ::: ' + resp);
  }
}


/*public class GoogleDriveController
{
    //Fetched from URL
    private String code ;
    private string key = '60690235412-6dvdp6tmm79siggsfri48otdr1tb5dfl.apps.googleusercontent.com' ;
    private string secret = 'Fr-8IWF7tCSELF9lGTsw9Ni_' ;
    private string redirect_uri = 'https://c.ap1.visual.force.com/apex/GoogleDrivePage' ;
    
    public GoogleDriveController()
    {
        system.debug('CCCCC---->>>');
        code = ApexPages.currentPage().getParameters().get('code') ;
        //Get the access token once we have code
        if(code != '' && code != null)
        {
            system.debug('---->>>');
            AccessToken() ;
            
        }
    }
    
    public PageReference DriveAuth()
    {
        //Authenticating
        PageReference pg = new PageReference(GoogleDriveAuthUri (key , redirect_uri)) ;
        return pg ;
    }
    
    public String GoogleDriveAuthUri(String Clientkey,String redirect_uri)
    {
        String key = EncodingUtil.urlEncode(Clientkey,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
        'client_id='+key+
        '&response_type=code'+
        '&scope=https://www.googleapis.com/auth/drive'+
        '&redirect_uri='+uri+
        '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
        '&login_hint=jsmith@example.com&'+
        'access_type=offline';
        return authuri;
    }
    
    
    public void AccessToken()
    {
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+code+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);

        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        system.debug('----->>>>>>'+resp);
        
        System.debug(' You can parse the response to get the access token ::: ' + resp);
   }
}*/