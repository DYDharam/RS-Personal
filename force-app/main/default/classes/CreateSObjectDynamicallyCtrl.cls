public with sharing class CreateSObjectDynamicallyCtrl {
    
    
    
    @AuraEnabled
    public static List<sobjectListNameNApi> getSobjectList_Apex() {
        List<sobjectListNameNApi> sobjectPickList = new List<sobjectListNameNApi>();
        try {
            for (Schema.SObjectType obj : Schema.getGlobalDescribe().values()){
                Schema.DescribeSObjectResult objDescription = obj.getDescribe();
                
                
                Schema.sObjectType objType = Schema.getGlobalDescribe().get(objDescription.getName());
                Schema.DescribeSObjectResult objDesc = objType.getDescribe();
                
                if(objDesc.isUpdateable() && objDesc.isCreateable() ) {
                    sobjectListNameNApi wrapSobject = new sobjectListNameNApi();
                    wrapSobject.label = objDescription.getLabel();
                    wrapSobject.value = objDescription.getName();
                    sobjectPickList.add(wrapSobject);
                }
                
            }
        } catch (Exception e) {
            System.debug('Get exception on line number ' + e.getLineNumber() +
                         '   due to following method getAllStudentRecords  ' + e.getMessage());
        }
        return sobjectPickList;
    }
        
    public class sobjectListNameNApi {
        @AuraEnabled
        public String label {set; get;}
        @AuraEnabled
        public String value {set; get;}
    }
    
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
        List<String> standardFieldLists = new List<String>{'OwnerId', 'CreatedById', 'LastModifiedById'};
            try {
                // When the Page Layout is Not Available.
                if(String.isBlank(pageLayoutName)) {
                    wrapperDetailsList = CreateSObjectDynamicallyCtrl.getAllFields_Apex(sObjectName, recordId);
                } else {
                    
                    if (String.isNotBlank(sObjectName)) {
                        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(String.valueOf(sObjectName)).getDescribe().fields.getMap();
                        for (Schema.SObjectField field: fieldMap.values()) {
                            Schema.DescribeFieldResult fieldResult = field.getDescribe();
                            
                            Schema.DisplayType lfielddataTypeO = fieldMap.get(fieldResult.getName()).getDescribe().getType();
                            String dataType = String.valueOf(lfielddataTypeO).ToLowerCase();
                            system.debug('dataType::::::: ' + dataType);
                            List<LightningRecordEditFormController.LayoutSection> layoutSectionWrapperList = new List<LightningRecordEditFormController.LayoutSection>();
                            layoutSectionWrapperList = LightningRecordEditFormController.getPageLayoutFields(pageLayoutName);
                            for(LightningRecordEditFormController.LayoutSection layoutSectionObject : layoutSectionWrapperList) {
                                //System.debug('layoutSectionObject::: ' + layoutSectionObject);
                                List<LightningRecordEditFormController.LayoutField> layoutFieldList = layoutSectionObject.lstFields;
                                for(LightningRecordEditFormController.LayoutField lf : layoutFieldList) {
                                    String fieldName = fieldResult.getName();
                                    if(String.isNotBlank(lf.fieldName) && String.isNotBlank(fieldName) && fieldName == lf.fieldName && !standardFieldLists.contains(fieldName)) {
                                        wrapperOfSObjectDetails wrapSobjD = new wrapperOfSObjectDetails();
                                        if(dataType == 'location') {
                                            fieldName = fieldName.replace('__c', '');
                                            wrapSobjD.value = '';
                                            wrapSobjD.fieldApiName = fieldName + '__Latitude__s';
                                            wrapSobjD.fieldApiName2 = fieldName + '__Longitude__s';
                                        } else {
                                            wrapSobjD.fieldApiName = fieldName;
                                        }
                                        
                                        
                                        
                                        if(lf.isReadOnly != null) {
                                            wrapSobjD.isReadOnly = true;
                                        } else {
                                            wrapSobjD.isReadOnly = false;
                                        }
                                        if(lf.isRequired != null) {
                                            wrapSobjD.isRequiredField = true;
                                        } else {
                                            wrapSobjD.isRequiredField = false;
                                        }
                                        if(dataType == 'picklist') {
                                            wrapSobjD.fieldPickListData = CreateSObjectDynamicallyCtrl.picklist_values(sObjectName, fieldName);
                                        } else if(dataType == 'reference') {
                                            Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
                                            for(Schema.SObjectType reference : f.getReferenceTo()) {
                                                wrapSobjD.lookupfieldType = reference.getDescribe().getName();
                                            }
                                        } else if(dataType == 'multipicklist') {
                                            wrapSobjD.dualPickListValues = CreateSObjectDynamicallyCtrl.dualPickListValues_Apex(sObjectName, fieldName);
                                        }
                                        wrapSobjD.fieldLabel = fieldResult.getLabel();
                                        wrapSobjD.fieldType = dataType;
                                        wrapSobjD.fieldValue = '';
                                        wrapperDetailsList.add(wrapSobjD);
                                        
                                        
                                        
                                        
                                        
                                    }
                                }
                            }
                            
                            
                            /*wrapperOfSObjectDetails wrapSobjD = new wrapperOfSObjectDetails();
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
                                        wrapSobjD.lookupfieldType = reference.getDescribe().getName();
                                    }
                                }
                                wrapSobjD.fieldType = dataType;
                                wrapSobjD.fieldValue = '';
                                wrapperDetailsList.add(wrapSobjD);
                            }*/
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
        //system.debug('fieldName::::::    ' + fieldName);
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
    
    public static List<picklistWrapper> dualPickListValues_Apex(String sObjectName, String sObjectFieldName) {
        List<picklistWrapper> dualPickListValuesWrapper = new List<picklistWrapper>();
        try {
            sObject sObjectType = Schema.getGlobalDescribe().get(sObjectName).newSObject();
            Schema.sObjectType objType = sObjectType.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            
            
            // Get a map of fields for the SObject
            map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
            // Get the list of picklist values for this field.
            list <Schema.PicklistEntry > values = fieldMap.get(sObjectFieldName).getDescribe().getPickListValues();

            // Add these values to the selectoption list.
            for (Schema.PicklistEntry a: values) {
                picklistWrapper plw = new picklistWrapper();
                plw.label = a.getValue();
                plw.value = a.getLabel();
                system.debug('plw::: ' + plw);
                dualPickListValuesWrapper.add(plw);
            }
            
            
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return dualPickListValuesWrapper;
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
        public String fieldApiName2 {
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
        public List<picklistWrapper> dualPickListValues {
            get; set;
        }
        @AuraEnabled
        public Boolean isReadOnly {
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
    
    @AuraEnabled
    public static List<wrapperOfSObjectDetails> saveSobjectRecord_Apex (String sObjectListAsString, String typeOfList, String sObjectName, String pageLayoutName) {
        List<wrapperOfSObjectDetails> wrapperDetailsList = new List<wrapperOfSObjectDetails>();
        List<sObject> sObjectList = new List<sObject>();
        //system.debug('sObjectListAsString::: ' + sObjectListAsString);
        Type t = Type.forName(typeOfList);
        sObjectList = (List<SObject>)JSON.deserialize(sObjectListAsString, t);
        try {
            insert sObjectList;
            wrapperDetailsList = CreateSObjectDynamicallyCtrl.getAllFields_Apex_Copy(sObjectName, '', pageLayoutName);
        } Catch (Exception Ex){
            System.debug('Error is :::::: ' + Ex.getMessage() + ' On Line Number ::::: ' + Ex.getLineNumber());
        }
        return wrapperDetailsList;
    }
    
    
    @AuraEnabled
    public static List<wrapperOfSObjectLWCDetails> getAllFieldsLWC_Apex (String sObjectName, String recordId) {
        List<wrapperOfSObjectLWCDetails> wrapperDetailsList = new List<wrapperOfSObjectLWCDetails>();
        try {
            if (String.isNotBlank(sObjectName)) {
                Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Map <String, Schema.SObjectField> fieldMap = schemaMap.get(String.valueOf(sObjectName)).getDescribe().fields.getMap();
                for (Schema.SObjectField field: fieldMap.values()) {
                    Schema.DescribeFieldResult fieldResult = field.getDescribe();
                    
                    Schema.DisplayType lfielddataTypeO = fieldMap.get(fieldResult.getName()).getDescribe().getType();
                    String dataType = String.valueOf(lfielddataTypeO).ToLowerCase();
                    wrapperOfSObjectLWCDetails wrapSobjD = new wrapperOfSObjectLWCDetails();
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
                        if(dataType.equalsIgnoreCase('string')) {
                            wrapSobjD.isString = true;
                        } else {
                            wrapSobjD.isString = false;
                        }
                        if(dataType.equalsIgnoreCase('fax')) {
                            wrapSobjD.isFax = true;
                        } else {
                            wrapSobjD.isFax = false;
                        }
                        if(dataType.equalsIgnoreCase('phone')) {
                            wrapSobjD.isPhone = true;
                        } else {
                            wrapSobjD.isPhone = false;
                        }
                        if(dataType.equalsIgnoreCase('date')) {
                            wrapSobjD.isDate = true;
                        } else {
                            wrapSobjD.isDate = false;
                        }
                        if(dataType.equalsIgnoreCase('datetime')) {
                            wrapSobjD.isDateTime = true;
                        } else {
                            wrapSobjD.isDateTime = false;
                        }
                        if(dataType.equalsIgnoreCase('email')) {
                            wrapSobjD.isEmail = true;
                        } else {
                            wrapSobjD.isEmail = false;
                        }
                        if(dataType.equalsIgnoreCase('integer')) {
                            wrapSobjD.isInteger = true;
                        } else {
                            wrapSobjD.isInteger = false;
                        }
                        if(dataType.equalsIgnoreCase('url')) {
                            wrapSobjD.isUrl = true;
                        } else {
                            wrapSobjD.isUrl = false;
                        }
                        if(dataType.equalsIgnoreCase('boolean')) {
                            wrapSobjD.isBoolean = true;
                        } else {
                            wrapSobjD.isBoolean = false;
                        }
                        if(dataType.equalsIgnoreCase('picklist')) {
                            wrapSobjD.isPickList = true;
                        } else {
                            wrapSobjD.isPickList = false;
                        }
                        if(dataType.equalsIgnoreCase('currency')) {
                            wrapSobjD.isCurrency = true;
                        } else {
                            wrapSobjD.isCurrency = false;
                        }
                        if(dataType.equalsIgnoreCase('double')) {
                            wrapSobjD.isDouble = true;
                        } else {
                            wrapSobjD.isDouble = false;
                        }
                        if(dataType.equalsIgnoreCase('textarea')) {
                            wrapSobjD.isTextArea = true;
                        } else {
                            wrapSobjD.isTextArea = false;
                        }
                        if(dataType.equalsIgnoreCase('reference')) {
                            wrapSobjD.isReference = true;
                        } else {
                            wrapSobjD.isReference = false;
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
    public Class wrapperOfSObjectLWCDetails {
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
        @AuraEnabled
        public Boolean isString {
            get; set;
        }
        @AuraEnabled
        public Boolean isFax {
            get; set;
        }
        @AuraEnabled
        public Boolean isPhone {
            get; set;
        }
        @AuraEnabled
        public Boolean isDate {
            get; set;
        }
        @AuraEnabled
        public Boolean isDateTime {
            get; set;
        }
        @AuraEnabled
        public Boolean isEmail {
            get; set;
        }
        @AuraEnabled
        public Boolean isInteger {
            get; set;
        }
        @AuraEnabled
        public Boolean isUrl {
            get; set;
        }
        @AuraEnabled
        public Boolean isBoolean {
            get; set;
        }
        @AuraEnabled
        public Boolean isPickList {
            get; set;
        }
        @AuraEnabled
        public Boolean isCurrency {
            get; set;
        }
        @AuraEnabled
        public Boolean isDouble {
            get; set;
        }
        @AuraEnabled
        public Boolean isTextArea {
            get; set;
        }
        @AuraEnabled
        public Boolean isReference {
            get; set;
        }
    }
}