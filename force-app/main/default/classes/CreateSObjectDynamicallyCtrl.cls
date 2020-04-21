public class CreateSObjectDynamicallyCtrl {
    
    // For the component of CreateSObjectWithPageLayout.
    
    
    // For the component of CreateSObjectDynamically.
    @AuraEnabled
    public static List<wrapSelectFromPickList> getPickListValues (String fieldsName, String strObjectName){
        try {
            if(fieldsName != null && fieldsName != ' ' && fieldsName != '' && String.isNotBlank(fieldsName)) {
                List<wrapSelectFromPickList> wrapList = new List<wrapSelectFromPickList>();
                Schema.SObjectType targetType =
                    Schema.getGlobalDescribe().get(string.valueOf(strObjectName));//From the Object Api name retrieving the SObject
                Sobject Object_name = targetType.newSObject();
                Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
                Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
                Map<String, Schema.SObjectField> field_map =
                    sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
                List<Schema.PicklistEntry> pick_list_values = field_map.get(
                    fieldsName).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
                for (Schema.PicklistEntry f : pick_list_values) {
                    wrapSelectFromPickList wsfpl = new wrapSelectFromPickList();
                    wsfpl.label = f.getLabel();
                    wsfpl.value = f.getValue();
                    wrapList.add(wsfpl);
                    system.debug('System debug Check:::: ');
                    system.debug('System debug Check:::::::: ');
                }
                if(wrapList.size() > 0) {
                    return wrapList;
                }
            }
        } catch (Exception e) {
            System.debug('Get exception on line number ' + e.getLineNumber() +
                         '   due to following method getAllStudentRecords  ' + e.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static List<wrapperOfSObjectDetails> getAllFields_Apex (String sObjectName, String recordId) {
        List<wrapperOfSObjectDetails> wrapperDetailsList = new List<wrapperOfSObjectDetails>();
        try {
            if (String.isNotBlank(sObjectName)) {
                Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Map <String, Schema.SObjectField> fieldMap = schemaMap.get(String.valueOf(sObjectName)).getDescribe().fields.getMap();
                for (Schema.SObjectField field: fieldMap.values()) {
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    
                    Schema.DisplayType lfielddataTypeO = fieldMap.get(fieldResult.getName()).getDescribe().getType();
                    String dataType = String.valueOf(lfielddataTypeO).ToLowerCase();
                    wrapperOfSObjectDetails wrapSobjD = new wrapperOfSObjectDetails();
                    if(fieldResult.isUpdateable() && fieldResult.isCreateable()) {
                        wrapSobjD.fieldLabel = fieldResult.getLabel();
                        String fieldName = fieldResult.getName();
                        wrapSobjD.fieldApiName = fieldName;
                        if(fieldResult.isCreateable()  && !fieldResult.isNillable() && !fieldResult.isDefaultedOnCreate() && (fieldResult.getType() != Schema.DisplayType.BOOLEAN)) {
                            wrapSobjD.isRequiredField = true;
                        } else {
                            wrapSobjD.isRequiredField = false;
                        }
                        if(dataType == 'picklist') {
                            wrapSobjD.fieldPickListData = CreateSObjectDynamicallyCtrl.picklist_values(sObjectName, fieldName);
                        } else if(dataType == 'reference') {
                            Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
                            for(Schema.SObjectType reference : f.getReferenceTo()) {
                                //System.debug('Lookup reference object name: ' + reference.getDescribe().getName());
                                //System.debug('Lookup reference object label: ' + reference.getDescribe().getLabel());
                                wrapSobjD.lookupfieldType = reference.getDescribe().getName();
                            }
                        }
                        wrapSobjD.fieldType = dataType;
                        wrapSobjD.fieldValue = '';
                        wrapperDetailsList.add(wrapSobjD);
                    }
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return wrapperDetailsList;
    }
    
    @AuraEnabled
    public static List<wrapperOfSObjectDetails> getAllFields_Apex_Copy (String sObjectName, String recordId, String pageLayoutName) {
        List<wrapperOfSObjectDetails> wrapperDetailsList = new List<wrapperOfSObjectDetails>();
        List<String> standardFieldLists = new List<String>{'ownerid'};
        try {
            if (String.isNotBlank(sObjectName)) {
                pageLayoutName = 'Lightning_Tutorials__c-New Test';
                Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Map <String, Schema.SObjectField> fieldMap = schemaMap.get(String.valueOf(sObjectName)).getDescribe().fields.getMap();
                
                
                List<String> fieldsApiNames = new List<String>();
                // When the Page Layout is Not Null.
                if(String.isNotBlank(pageLayoutName)) {
                    List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {pageLayoutName});
                    Metadata.Layout layoutMd = (Metadata.Layout) layouts.get(0);
                    for (Metadata.LayoutSection section : layoutMd.layoutSections) {
                        for (Metadata.LayoutColumn column : section.layoutColumns) {
                            if (column.layoutItems != null) {
                                for (Metadata.LayoutItem item : column.layoutItems) {
                                    System.debug(item.field);
                                    fieldsApiNames.add(item.field);
                                }
                            }
                        }
                    }
                }
				system.debug('fieldsApiNames:::: ' + fieldsApiNames);                
                system.debug('fieldsApiNames:SSS::: ' + fieldsApiNames.size());                
                
                for (Schema.SObjectField field: fieldMap.values()) {
                    
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    
                    Schema.DisplayType lfielddataTypeO = fieldMap.get(fieldResult.getName()).getDescribe().getType();
                    String dataType = String.valueOf(lfielddataTypeO).ToLowerCase();
                    
                    
                    if(fieldResult.isUpdateable() && fieldResult.isCreateable()) {
                        
                        String fieldName = fieldResult.getName();
                        
                        
                        if(fieldsApiNames.contains(fieldName) && !standardFieldLists.contains(fieldName.ToLowerCase()) && fieldsApiNames.size() > 0) {
                            System.debug('Page Layout: Available :::: ');
                            wrapperDetailsList.add(CreateSObjectDynamicallyCtrl.getWrapperObject_Apex(fieldResult, sObjectName, dataType));
                        } else if(!standardFieldLists.contains(fieldName.ToLowerCase())){
                            System.debug('Not Page Layout::::: ');
                            wrapperDetailsList.add(CreateSObjectDynamicallyCtrl.getWrapperObject_Apex(fieldResult, sObjectName, dataType));
                        }
                        
                    }
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return wrapperDetailsList;
    }
    
    public static wrapperOfSObjectDetails getWrapperObject_Apex(Schema.DescribeFieldResult fieldResult, String sObjectName, String dataType) {
        wrapperOfSObjectDetails wrapSobjD = new wrapperOfSObjectDetails();
        wrapSobjD.fieldLabel = fieldResult.getLabel();
        String fieldName = fieldResult.getName();
        system.debug('fieldName::::::    ' + fieldName);
        wrapSobjD.fieldApiName = fieldName;
        if(fieldResult.isCreateable()  && !fieldResult.isNillable() && !fieldResult.isDefaultedOnCreate() && (fieldResult.getType() != Schema.DisplayType.BOOLEAN)) {
            wrapSobjD.isRequiredField = true;
        } else {
            wrapSobjD.isRequiredField = false;
        }
        if(dataType == 'picklist') {
            wrapSobjD.fieldPickListData = CreateSObjectDynamicallyCtrl.picklist_values(sObjectName, fieldName);
        } else if(dataType == 'reference') {
            Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
            for(Schema.SObjectType reference : f.getReferenceTo()) {
                //System.debug('Lookup reference object name: ' + reference.getDescribe().getName());
                //System.debug('Lookup reference object label: ' + reference.getDescribe().getLabel());
                wrapSobjD.lookupfieldType = reference.getDescribe().getName();
            }
        }
        wrapSobjD.fieldType = dataType;
        wrapSobjD.fieldValue = '';
        return wrapSobjD;
    }
    
    /*
* 
List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {'Account-Account Layout'});
Metadata.Layout layoutMd = (Metadata.Layout) layouts.get(0);
for (Metadata.LayoutSection section : layoutMd.layoutSections) {
	for (Metadata.LayoutColumn column : section.layoutColumns) {
		if (column.layoutItems != null) {
			for (Metadata.LayoutItem item : column.layoutItems) {
				System.debug(item.field);
			}
		}
	}
}
*/
    
    @AuraEnabled
    public static List<String> getAllFields (String sObjectName, String recordId) {
        List<String> fieldsList = new List<String>();
        try {
            fieldsList = CreateSObjectDynamicallyCtrl.getFieldsName_Apex(sObjectName);
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return fieldsList;
    }
    public Class wrapperOfSObjectDetails {
        @AuraEnabled
        public String fieldLabel {
            get; set;
        }
        @AuraEnabled
        public String fieldApiName {
            get; set;
        }
        @AuraEnabled
        public String lookupfieldType {
            get; set;
        }
        @AuraEnabled
        public String fieldType {
            get; set;
        }
        @AuraEnabled
        public String fieldValue {
            get; set;
        }
        @AuraEnabled
        public String value {
            get; set;
        }
        @AuraEnabled
        public List<picklistWrapper> fieldPickListData {
            get; set;
        }
        @AuraEnabled
        public Boolean isRequiredField {
            get; set;
        }
    }
    
    public Class picklistWrapper {
        @AuraEnabled
        public String label {set; get;}
        @AuraEnabled
        public String value {set; get;}
    }
    
    
    public Class wrapSelectFromPickList {
        @AuraEnabled
        public String label {set; get;}
        @AuraEnabled
        public String value {set; get;}
    }
    
    public static List<picklistWrapper> picklist_values(String object_name, String field_name) {
        List<picklistWrapper> getPickList = new List<picklistWrapper>();
        try {
            String[] values = new String[]{};
                String[] types = new String[]{object_name};
                    Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
            for(Schema.DescribeSobjectResult res : results) {
                for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues()) {
                    if (entry.isActive()) {
                        picklistWrapper plw = new picklistWrapper();
                        plw.label = entry.getValue();
                        plw.value = entry.getValue();
                        getPickList.add(plw);
                    }
                }
            }   
        } Catch (Exception Ex){
            System.debug('Error is :::::: ' + Ex.getMessage() + ' On Line Number ::::: ' + Ex.getLineNumber());
        }
        return getPickList;
    }
    
    public static List<String> getObjectFields(String selectedObject) {
        List<String> fieldNames = new List<String>();
        try {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);
            Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
            for (String fieldName: fieldMap.keySet()) {  
                String fName = fieldMap.get(fieldName).getDescribe().getLabel();
                fieldNames.add(fName);
            } 
        } Catch (Exception Ex){
            System.debug('Error is :::::: ' + Ex.getMessage() + ' On Line Number ::::: ' + Ex.getLineNumber());
        }
        return fieldNames;
    } 
    
    public static String getFieldType(String sObjectName, String fieldName){
        // Assume that "sObjectName" is populated elsewhere
        Schema.SObjectType t = Schema.getGlobalDescribe().get(sObjectName);
        Schema.DescribeSObjectResult r = t.getDescribe();
        Schema.DescribeFieldResult f = r.fields.getMap().get(fieldName).getDescribe();
        String fieldType = String.valueOf(f.getType());
        return fieldType;
    }
    
    public static List<String> getFieldsName_Apex (String selectedObject) {
        List<String> fieldsList = new List<String>();
        try{
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(selectedObject);
            Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
            //Map<String, Schema.SObjectField> map = Schema.SObjectType.Custom1__c.fields.getMap();
            for (String fieldName: fieldMap.keySet()) {  
                String mylabel;
                if(fieldMap.get(fieldName).getDescribe().isUpdateable() && fieldMap.get(fieldName).getDescribe().isCreateable() && fieldMap.get(fieldName).getDescribe().isAccessible()) {
                    mylabel = fieldMap.get(fieldName).getDescribe().getName();
                    system.debug('mylabel-->>>'+mylabel);
                    if(mylabel != 'Salutation' && mylabel != 'OtherGeocodeAccuracy' && mylabel != 'MailingGeocodeAccuracy') {
                        fieldsList.add(mylabel);
                    }
                }
            }
        } Catch (Exception Ex){
            System.debug('Error is :::::: ' + Ex.getMessage() + ' On Line Number ::::: ' + Ex.getLineNumber());
        }
        return fieldsList;
    }
    
    @AuraEnabled
    public static List<sObject> saveSobjectRecord_Apex (String sObjectListAsString, String typeOfList) {
        List<sObject> sObjectList = new List<sObject>();
        try {
            Type t = Type.forName(typeOfList);
            sObjectList = (List<SObject>)JSON.deserialize(sObjectListAsString, t);
            insert sObjectList;
        } Catch (Exception Ex){
            System.debug('Error is :::::: ' + Ex.getMessage() + ' On Line Number ::::: ' + Ex.getLineNumber());
        }
        return sObjectList;
    }
    
     
}