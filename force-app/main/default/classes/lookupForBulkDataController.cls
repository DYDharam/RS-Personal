/*
 * Created by DY on 4/10/2019.
 */
public class lookupForBulkDataController {
    @AuraEnabled
    public static List<Account> getContact_Apex () {
        List<Account> accList = new List<Account>();
        try{
            accList = [select Id, Name From Account LIMIT 200];
        } catch (Exception e) {
            System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method   ' + e.getMessage());
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage() + e.getLineNumber());
        }
        return accList;
    }


	@AuraEnabled
	public static sObject getSobjectRecord_Apex (String strObjectName, String selectedRecord) {
		List<sObject> returnList = new List < sObject > ();
		try {
			system.debug('selectedRecord-->>>> '+selectedRecord);
			if(String.isNotBlank(selectedRecord)) {
				String fieldsName = lookupForBulkDataController.getFieldsNameFromObjectName_Apex(strObjectName);
				String sQuery = 'select ' + fieldsName + ' FROM ' + strObjectName + ' WHERE Id =: selectedRecord';
				system.debug(sQuery);
				returnList = Database.query(sQuery);
				if(returnList.size() > 0) {
					return returnList[0];
				}
			}
		} catch (Exception e) {
			System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method   ' + e.getMessage());
			throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage() + e.getLineNumber());
		}
		return null;
	}
	@AuraEnabled
	public static List < sObject > fetchLookUpValues (String searchKeyWord, String ObjectName) {
		List < sObject > returnList = new List < sObject > ();
		try {
			system.debug('ObjectName-->' + ObjectName);
			String searchKey = '';
			if(String.isNotBlank(searchKeyWord)) {
				searchKey = searchKeyWord + '%';
			}


			String sQuery = '';
			String fieldsName = lookupForBulkDataController.getFieldsNameFromObjectName_Apex(ObjectName);
			sQuery =  'select ' + fieldsName + ' FROM ' +ObjectName + ' ';
			// Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5
			if(String.isNotBlank(searchKey)) {
				sQuery += 'where Name LIKE: searchKey ';
			}
			sQuery += 'order by createdDate DESC limit 5';
			List < sObject > lstOfRecords = Database.query(sQuery);

			for (sObject obj: lstOfRecords) {
				returnList.add(obj);
			}
		} catch (Exception e) {
			System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method   ' + e.getMessage());
			throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage() + e.getLineNumber());
		}
		return returnList;
	}
	public static String getFieldsNameFromObjectName_Apex (String sObjectName) {
		String allFieldsApiNames = '';
		try {
			if(String.isNotBlank(sObjectName)) {
				SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
				DescribeSObjectResult objDef = objToken.getDescribe();
				Map<String, SObjectField> fields = objDef.fields.getMap();
				Set<String> fieldSet = fields.keySet();
				for(String s:fieldSet)
					{
						SObjectField fieldToken = fields.get(s);
						DescribeFieldResult selectedField = fieldToken.getDescribe();
						allFieldsApiNames += String.valueOf(selectedField.getName() + ',');
					}
				allFieldsApiNames = allFieldsApiNames.removeEnd(',');
				system.debug('allFieldsApiNames->>> '+allFieldsApiNames);
			}
		} catch (Exception e) {
			System.debug('Get exception on line number ' + e.getLineNumber() +
					'   due to following method getRecordType  ' + e.getMessage());
		}
		return allFieldsApiNames;
	}
}