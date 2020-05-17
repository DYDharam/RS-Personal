public class RecentViewDynamicallyCtrl {
	
    public static List<sObject> getFieldsNameFromObjectName_Apex(String sObjectName, String innerQueryString) {
        List<sObject> sObjectRecordList = new List<sObject>();
        String sObjectQuery = '';
        String allFieldsApiNames = '';
        //Set<String> excludeObjectList = new Set<String>{'ContentDocument', 'ListView', 'Dashboard'};
        Set<String> includeObjectList = new Set<String>{'Opportunity', 'Contact', 'Account', 'User', 'Contract', 'Case'};
        List<CreateSObjectDynamicallyCtrl.sobjectListNameNApi> sobjectList = CreateSObjectDynamicallyCtrl.getSobjectList_Apex();
        if(sobjectList.size() > 0) {
            for(CreateSObjectDynamicallyCtrl.sobjectListNameNApi sObjectListName : sobjectList) {
                if((sObjectListName.value).contains('__c')) { // Only custom object will add.
                    includeObjectList.add(sObjectListName.value);
                }
            }
        }
        try {
            if (String.isNotBlank(sObjectName)) {
                SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
                DescribeSObjectResult objDef = objToken.getDescribe();
                Map<String, SObjectField> fields = objDef.fields.getMap();
                Set<String> fieldSet = fields.keySet();
                for (String s : fieldSet) {
                    SObjectField fieldToken = fields.get(s);
                    DescribeFieldResult selectedField = fieldToken.getDescribe();
                    allFieldsApiNames += String.valueOf(selectedField.getName() + ', ');
                }
                allFieldsApiNames = allFieldsApiNames.removeEnd(', ');
                sObjectQuery = 'SELECT ' + allFieldsApiNames + innerQueryString + ' FROM ' + sObjectName + ' Where Type IN: includeObjectList' + ' LIMIT 20';
                sObjectRecordList = Database.query(sObjectQuery);
            }
        } catch (Exception e) {
            System.debug('Get exception on line number ' + e.getLineNumber() + ' due to following method getRecordType ::: ' + e.getMessage());
        }
        return sObjectRecordList;
    }
    @AuraEnabled
    public static List<sObjectNIconDetailsWrapper> getRecentViewItemsDetail_Apex(String sObjectName) { //RecentlyViewed
        List<sObjectNIconDetailsWrapper> sObjectNIconWrapper = new List<sObjectNIconDetailsWrapper>();
        List<RecentlyViewed> sobjList = new List<RecentlyViewed>();
        sobjList = RecentViewDynamicallyCtrl.getFieldsNameFromObjectName_Apex('RecentlyViewed', '');
        //system.debug(describe.getLabel());
        for(RecentlyViewed sObjectRecord : sobjList) {
            String objectName = RecentViewDynamicallyCtrl.getSojectNameUsingApi(String.valueOf(sObjectRecord.get('Type')));
            if(!objectName.contains(' ')) {
                sObjectNIconDetailsWrapper sObjectNIconWrapperObj = new sObjectNIconDetailsWrapper();
                sObjectNIconWrapperObj.sObjectRecord = sObjectRecord;
                sObjectNIconWrapperObj.recordUrl = '/lightning/r/' + sObjectRecord.get('Type') + '/' + sObjectRecord.get('Id') + '/view';
                Map<String,String> iconPropertyMap = new Map<String,String>();
                iconPropertyMap = RecentViewDynamicallyCtrl.retrieveIconForObject(String.valueOf(sObjectRecord.get('Type')));
                //sObjectNIconWrapperObj.iconStyle = iconPropertyMap.get('iconStyle');
                //sObjectNIconWrapperObj.iconURL = iconPropertyMap.get('iconURL');
                String sampleIconUrl = iconPropertyMap.get('iconURL');
                String getIconNameCustom = '';
                String getIconNameStandard = '';
                if(sampleIconUrl.contains('/img/icon/t4v35/custom/')) {
                    String[] strList = sampleIconUrl.split('custom/');
                    String newZeroIndex = strList[1];
                    String[] newStrList = newZeroIndex.split('_');
                    getIconNameCustom = newStrList[0];
                } else if(sampleIconUrl.contains('/img/icon/t4v35/standard/')) {
                    String[] strList = sampleIconUrl.split('standard/');
                    String newZeroIndex = strList[1];
                    String[] newStrList = newZeroIndex.split('_');
                    getIconNameStandard = newStrList[0];
                }
                sObjectNIconWrapperObj.objectName = objectName;
                if(String.valueOf(sObjectRecord.get('Type')).contains('__c')) {
                    if(String.isNotBlank(getIconNameCustom.toLowercase())) {
                        sObjectNIconWrapperObj.iconName = 'custom:' + getIconNameCustom.toLowercase();
                    } else {
                        sObjectNIconWrapperObj.iconName = 'custom:' + iconPropertyMap.get('iconURL');
                    }
                } else {
                    if(String.isNotBlank(getIconNameStandard.toLowercase())) {
                        sObjectNIconWrapperObj.iconName = 'standard:' + getIconNameStandard.toLowercase();
                    } else {
                        sObjectNIconWrapperObj.iconName = 'standard:' + objectName.toLowercase();
                    }
                }
                sObjectNIconWrapper.add(sObjectNIconWrapperObj);
            }  
        }
        return sObjectNIconWrapper;
    }
    public static String getSojectNameUsingApi (String objectName) {
        List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{objectName}); // this can accept list of strings, we describe only one object here
        String objectLabel = describeSobjectsResult[0].getLabel();
        return objectLabel;
    }
    public class sObjectNIconDetailsWrapper{
        @AuraEnabled
        public sObject sObjectRecord {set; get;}
        @AuraEnabled
        public String iconStyle {set; get;}
        @AuraEnabled
        public String iconURL {set; get;}
        @AuraEnabled
        public String objectName {set; get;}
        @AuraEnabled
        public String iconName {set; get;}
        @AuraEnabled
        public String recordUrl {set; get;}
    }
    public static Map<String,String> retrieveIconForObject(String sObjectName) {    
        String iconStyle;
        String iconURL;
        String iconTag;
        Map<String,String>   iconPropertyMap = new Map<String,String>();
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        for(Schema.DescribeTabSetResult tsr : tabSetDesc){
            tabDesc.addAll(tsr.getTabs());
        }
        for(Schema.DescribeTabResult tr : tabDesc) {
            if( sObjectName == tr.getSobjectName() ) {
                if(!tr.getIcons().isEmpty()){
                    iconDesc.addAll(tr.getIcons());
                }else{
                    if( tr.isCustom() == true ) {
                        iconStyle = 'slds-icon-standard-custom';
                        iconURL   = '/img/icon/t4v35/standard/custom_120.png';
                    } else {
                        iconStyle = 'slds-icon-standard-' + sObjectName.toLowerCase();
                        iconURL   = '/img/icon/t4v35/standard/' + sObjectName.toLowerCase() + '_120.png';
                    }
                }
            }
        }
        for (Schema.DescribeIconResult ir : iconDesc) {
            if(ir.getTheme() =='custom' && !ir.getContentType().startsWith('image/svg')){//custom icon thats not an svg
                iconTag   = 'custom';
                iconURL   = ir.getURL();
                iconStyle = 'slds-icon-standard-custom';
                break;
            }else if(ir.getWidth() == 120 && ir.getTheme() =='theme4' && ir.getContentType() == 'image/png'){//large lightning icon image
                if(ir.getURL().contains('/custom/')){ //Icon is from the Custom Sprite
                    iconTag    = ir.getURL().substringBetween('custom/','.png').substringBefore('_');
                    iconURL    = '/img/icon/t4v35/custom/' + iconTag + '_120.png';
                    iconStyle  = 'slds-icon-custom-'+ iconTag;
                    break;
                }else if(ir.getURL().contains('/standard/')){//Icon is from the Standard Sprite
                    iconTag    = ir.getURL().substringBetween('standard/','.png').substringBefore('_');
                    iconURL    = '/img/icon/t4v35/standard/' + iconTag + '_120.png';
                    iconStyle  = 'slds-icon-standard-'+ iconTag;
                    break;
                }
            }
        }
        //if no icons are found, just default to the Custom lightning icon
        if(iconStyle == null){
            iconStyle = 'slds-icon-standard-custom';
            String u='/img/icon/t4v35/custom/custom3.svg';
            Integer s = u.indexOf('/custom/') + '/custom/'.length(),e = u.length() - 4;
            u = u.substring(s, e);
            iconURL   = u; //'/img/icon/t4v35/standard/custom_120.png';
            iconTag   = 'No Lightning Icon Found';
        }
        //return a map with our properties for the front end
        iconPropertyMap.put('iconStyle',iconStyle);
        iconPropertyMap.put('iconURL',  iconURL);
        return iconPropertyMap;
    }
}