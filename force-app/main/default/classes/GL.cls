public class GL {
    
    public void refresh() {
        
        HttpRequest req2 = new HttpRequest();
        req2.setEndpoint(wayMap.get(way) + ip + (way == '3'? '/json' : '') );
        req2.setMethod('GET');
        Http http = new Http();
        HTTPResponse res2 = http.send(req2);
        if(res2.getStatusCode()==200) {
            
            Object o = json.deserialize(res2.getBody(),clsMap.get(way));
            if ( way == '1' || way == '2' ) {
                iwan i = (iwan) o;
                longitude = i.longitude;
                latitude = i.latitude;
            } else {
                ipinfo ii = (ipinfo) o;
                String[] ss = ii.loc.split(',');
                longitude = ss[1];
                latitude = ss[0];
            }
            
        }
    }
    
    public String longitude { get; set; }
    
    public String latitude { get; set; }
    
    public String ip { get {
        ip = ApexPages.currentPage().getParameters().get('ip');
        if (ip == null) {
            ip = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }
        return ip;
    } set;}
    
    public String way { get {
        if ( way == null ) {
            way = ApexPages.currentPage().getParameters().get('way');
        }
        if ( way == null ) {
            way = '1';
        }
        return way;
    } set;}
    
    
    Map<String, String> wayMap = new Map<String, String>{'1'=>'http://freegeoip.lwan.ws/json/','2'=>'http://www.telize.com/geoip/','3'=>'http://ipinfo.io/'};
        Map<String, System.Type> clsMap = new Map<String, System.Type>{'1'=>iwan.class,'2'=>iwan.class,'3'=>ipinfo.class};
            public GL() {
                system.debug('clsMap ::::::: ' + clsMap);
                refresh();
            }
    
    public class iwan{
        String country_name;
        String country_code;
        String region_name;
        String region_code;
        String city;
        String zipcode;
        String latitude;
        String longitude;
        String ip;
        String metro_code;
        String areacode;
    }
    
    public class ipinfo{
        String ip;
        String city;
        String hostname;
        String region;
        String country;
        String loc;
        String org;
    }
    
}