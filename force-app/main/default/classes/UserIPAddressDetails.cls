@RestResource(urlMapping='/UserIPAddressDetails/*')
global with sharing class UserIPAddressDetails {
    @HttpPost
    global static String UserIPAddressDetails_Apex() {
        String Ip = Auth.SessionManagement.getCurrentSession().get('SourceIp'); //'27.6.222.43';
        system.debug('Ip-->>> ' + Ip);
        return Ip;
    }
}