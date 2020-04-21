public class LightningQuickLinkesController {
    
    @AuraEnabled
    public static List<cusWrapperOfObjectNIcons> getObjectNameWithIcons(Boolean isStandard, Boolean isCustom) {
        List<cusWrapperOfObjectNIcons> cusWrapperOfObjectNIconsList = new List<cusWrapperOfObjectNIcons>();
        //List<String> objectNameList = UtilityClass.objectNameList(true, true, false);
        for ( Schema.SObjectType objDetails : Schema.getGlobalDescribe().values() ) {
            Schema.DescribeSObjectResult objResult = objDetails.getDescribe();
            //system.debug( 'Sobject: ' + objResult );
            //system.debug( 'Sobject API Name: ' + objResult.getName() );
            //system.debug( 'Sobject Label Name: ' + objResult.getLabel() );
            String objectApiName = objResult.getName();
            system.debug('objectApiName::: ' + objectApiName);
            String objectPluralName = objResult.getLabel();
            cusWrapperOfObjectNIcons cusWrapperObjects = new cusWrapperOfObjectNIcons();
            if(isStandard && (!objResult.isCustom())) {
                cusWrapperOfObjectNIconsList.add(LightningQuickLinkesController.getCusWrapperObjectDtailsHelper(objectApiName, objectPluralName));
            }
            if(isCustom && (objResult.isCustom())) {
                cusWrapperOfObjectNIconsList.add(LightningQuickLinkesController.getCusWrapperObjectDtailsHelper(objectApiName, objectPluralName));
            }
            system.debug('cusWrapperOfObjectNIconsList:: ' + cusWrapperOfObjectNIconsList);
        }
        return cusWrapperOfObjectNIconsList;
    }
    
    @AuraEnabled
    public static cusWrapperOfObjectNIcons getCusWrapperObjectDtailsHelper (String objectApiName, String objectPluralName) {
        system.debug('objectApiName:::: ' + objectApiName);
        system.debug('objectPluralName:::: ' + objectPluralName);
        cusWrapperOfObjectNIcons cusWrapperObjects = new cusWrapperOfObjectNIcons();
        cusWrapperObjects.objectNameApi = objectApiName;
        cusWrapperObjects.objectNameLabel = objectPluralName;
        if(objectApiName.contains('__c')) {
            cusWrapperObjects.isCustom = true;
            cusWrapperObjects.isStandard = false;
        } else {
            cusWrapperObjects.isStandard = true;
            cusWrapperObjects.isCustom = false;
        }
        List<String> iconName = new List<String>();
        String objectNameAndIcons = UtilityClass.getIconName(objectApiName);
        system.debug('objectNameAndIcons::: ' + objectNameAndIcons);
        if(objectNameAndIcons != null && objectNameAndIcons.contains(':')) {
            iconName = objectNameAndIcons.split(':');
            cusWrapperObjects.iconName = iconName[1];
        } else {
            cusWrapperObjects.iconName = 'empty';
        }	
        cusWrapperObjects.objectNameNIcon = objectNameAndIcons;
        objectNameAndIcons = '';
        return cusWrapperObjects;
    }
    
    @AuraEnabled
    public static String getIconName(String sObjectName){
        String u;
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        
        for(Schema.DescribeTabSetResult tsr : tabSetDesc) { tabDesc.addAll(tsr.getTabs()); }
        
        for(Schema.DescribeTabResult tr : tabDesc) {
            if( sObjectName == tr.getSobjectName() ) {
                if( tr.isCustom() == true ) {
                    iconDesc.addAll(tr.getIcons());
                } else {
                    u = 'standard:' + sObjectName.toLowerCase();
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if (ir.getContentType() == 'image/svg+xml'){
                u = 'custom:' + ir.getUrl().substringBetween('custom/','.svg').substringBefore('_');
                break;
            }
        }
        system.debug('u::: ' + u);
        return u;
    }
    public class cusWrapperOfObjectNIcons{
        @AuraEnabled
        public String objectNameLabel {set; get;}
        @AuraEnabled
        public String objectNameApi {set; get;}
        @AuraEnabled
        public String iconName {set; get;}
        @AuraEnabled
        public String objectNameNIcon {set; get;}
        @AuraEnabled
        public Boolean isCustom {set; get;}
        @AuraEnabled
        public Boolean isStandard {set; get;}
    }
}