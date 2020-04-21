/*
 * Created by DY on 3/11/2019.
 */
public class UtilBestApex {
	/*
	 * Purpose	:	to get realtedList From ObjectName.
	 List<prettyPrint> objectNameList = UtilBestApex.getAllRealatedChildName_Apex();
	 system.debug('objectNameList-> '+objectNameList);
	 */
	public static List<sObjectType> getAllRealatedChildName_Apex(sObject sObjectName) {
		List<sObjectType> prettyPrint = new List<sObjectType>();
		try {
			Schema.DescribeSObjectResult R = Stock__c.SObjectType.getDescribe();
			List<Schema.ChildRelationship> C = R.getChildRelationships();
			for (Schema.ChildRelationship cr : C) {
				String objectName = String.valueOf(cr.getChildSobject());
				//system.debug('cr->> '+objectName);
				//if(objectName.contains('__c') && !objectName.contains('CanaryAMS__') && !objectName.contains('AcctSeed__') && !objectName.equals('CanaryAMS__Accord_PDF__c') && !objectName.equals('CanaryAMS__Documents__c	')) {
					prettyPrint.add(cr.getChildSobject());
				//}
			}
			system.debug('prettyPrint-->> ' + prettyPrint.size());
		} catch (Exception e) {
			System.debug('Get exception on line number ' + e.getLineNumber() +
					'   due to following method getRecordType  ' + e.getMessage());
		}
		return prettyPrint;
	}
	/*
	 * Purpose	:	to get fieldsName From ObjectName.
	 List<String> objectNameList = UtilBestApex.getFieldsNameFromObjectName_Apex('Contact');
	 system.debug('objectNameList-> '+objectNameList);
	 */
	public static List<String> getFieldsNameFromObjectName_Apex (String sObjectName) {
		List<String> fieldsList = new List<String>();
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
					//System.debug(selectedField.getName());
					fieldsList.add(selectedField.getName());
				}
				system.debug('fieldsList->>> '+fieldsList);
			}
		} catch (Exception e) {
			System.debug('Get exception on line number ' + e.getLineNumber() +
					'   due to following method getRecordType  ' + e.getMessage());
		}
		return fieldsList;
	}
	/*
	 * Purpose	:	to get the refrence type of the field.
	 String objectName = UtilBestApex.getReferenceType_Apex('Stock_Details__c', 'Stock__c');
	 system.debug('objectName-> '+objectName);
	 */
	public static String getReferenceType_Apex (String sObjectName, String fieldName) {
		String refresnceType = '';
		try {
			Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
			for(Schema.SObjectType reference : f.getReferenceTo()) {
				System.debug('Lookup reference object name: ' + reference.getDescribe().getName());
				System.debug('Lookup reference object label: ' + reference.getDescribe().getLabel());
				refresnceType = reference.getDescribe().getName();
			}
		} catch (Exception e) {
			System.debug('Get exception on line number ' + e.getLineNumber() +
					'   due to following method getRecordType  ' + e.getMessage());
		}
		return refresnceType;
	}

	/*
	 * Purpose	:	to get the Field type.
	 String fieldType = UtilBestApex.getFieldType_Apex('Contact', 'AccountId');
	 system.debug('fieldType-->>> '+fieldType);
	 */
	public static String getFieldType_Apex (String sObjectName, String fieldName) {
		String fieldType = '';
		try {
			Map<String, Schema.SObjectField> M;
			M = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
			Schema.SObjectField field = M.get(fieldName);
			Schema.DisplayType FldType = field.getDescribe().getType();
			fieldType = String.valueOf(FldType);
		} catch (Exception e) {
			System.debug('Get exception on line number ' + e.getLineNumber() +
					'   due to following method getRecordType  ' + e.getMessage());
		}
		return fieldType;
	}
	/*
	 *  get ObjectName From the Id of the record.
	 */
	public void getSobjectName_Apex() {
		List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
		Map<String,String> objectMap = new Map<String,String>();
		for(Schema.SObjectType f : gd)
		{
			objectMap.put(f.getDescribe().getKeyPrefix(), f.getDescribe().getName());
		}
		String sampleId ='0017F00001YwiLm';
		String prefix =  sampleId.substring(0,3);
		String objectName = objectMap.get(prefix);
		System.debug('** SObject Name ** '+objectName);
	}
	public static void introductionOfMap_Apex () {
		Map<Account, Map<List<Contact>, List<Opportunity>>> accountIdVsContactListOpportunityListMap = new Map<Account, Map<List<Contact>, List<Opportunity>>>();
		List<Account> accList = new List<Account>();
		List<Contact> conList = new List<Contact>();
		List<Opportunity> oppList = new List<Opportunity>();
		Set<Id> accountIds = new Set<Id>();
		accList = [SELECT Id, Name FROM Account LIMIT 1000];
		for(Account acc : accList) {
			accountIds.add(acc.Id);
		}
		conList = [SELECT Id, Name, AccountId From Contact WHERE AccountId IN: accountIds];
		oppList = [SELECT Id, Name, AccountId From Opportunity WHERE AccountId IN: accountIds];
		System.debug('conList :: ' + conList);
		System.debug('oppList :: ' + oppList);
		Map<Id, Account> mapAccountIdVsAccount = new Map<Id, Account>();
		Map<Account, List<Contact>> mapAccountVsContact = new Map<Account, List<Contact>>();
		Map<Account, List<Opportunity>> mapAccountVsOpportunity = new Map<Account, List<Opportunity>>();
		for(Account acc : accList) {
			mapAccountVsContact.put(acc, new List<Contact>());
			mapAccountVsOpportunity.put(acc, new List<Opportunity>());
			mapAccountIdVsAccount.put(acc.Id, acc);
		}
		system.debug(mapAccountIdVsAccount);
		for(Contact con : conList) {
			if(mapAccountIdVsAccount.containsKey(con.AccountId) && mapAccountVsContact.containsKey(mapAccountIdVsAccount.get(con.AccountId))) {
				mapAccountVsContact.get(mapAccountIdVsAccount.get(con.AccountId)).add(con);
			}
		}
		for(Opportunity opp : oppList) {
			if(mapAccountIdVsAccount.containsKey(opp.AccountId) && mapAccountVsOpportunity.containsKey(mapAccountIdVsAccount.get(opp.AccountId))) {
				mapAccountVsOpportunity.get(mapAccountIdVsAccount.get(opp.AccountId)).add(opp);
			}
		}

		system.debug('mapAccountVsContact-->> '+mapAccountVsContact);
		system.debug('mapAccountVsOpportunity-->> '+mapAccountVsOpportunity);

		if(accList.size() > 0){
			for(Account ac : accList){
				if(!accountIdVsContactListOpportunityListMap.containsKey(ac)){
					accountIdVsContactListOpportunityListMap.put(ac, new Map<List<Contact>, List<Opportunity>>());
				}
				accountIdVsContactListOpportunityListMap.get(ac).put(mapAccountVsContact.get(ac), mapAccountVsOpportunity.get(ac));
			}
		}
		system.debug('accountIdVsContactListOpportunityListMap :::: ' + accountIdVsContactListOpportunityListMap);

	}
	public static void getAccoutRelatedOpportinityContact(){
		List<Contact> contactRelatedAccountList = new List<Contact>();
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityRelatedAccountList = new List<Opportunity>();

		Set<Id> accountIdsSet = new Set<Id>();

		Map<Id, List<Contact>> accountIdsVsContactListMap = new Map<Id, List<Contact>>();
		Map<Id, List<Opportunity>> accountIdsVsOpportunityListMap = new Map<Id, List<Opportunity>>();
		Map<Id, Map<List<Contact>, List<Opportunity>>> accountIdVsContactListOpportunityListMap = new Map<Id, Map<List<Contact>, List<Opportunity>>>();

		contactRelatedAccountList = [SELECT Id, AccountId
		FROM Contact
		WHERE AccountId != null
		LIMIT 49999];

		opportunityRelatedAccountList = [SELECT Id,
		AccountId
		FROM Opportunity
		WHERE AccountId != null
		LIMIT 49999];

		accountList = [SELECT Id,
		Name
		FROM Account
		WHERE Id IN : accountIdsSet];

		if(contactRelatedAccountList.size() > 0){
			for(Contact conObject : contactRelatedAccountList){
				accountIdsSet.add(conObject.AccountId);

				if(!accountIdsVsContactListMap.containsKey(conObject.AccountId)){
					accountIdsVsContactListMap.put(conObject.AccountId, new List<Contact>());
				}
				accountIdsVsContactListMap.get(conObject.AccountId).add(conObject);
			}
		}

		if(opportunityRelatedAccountList.size() > 0){
			for(Opportunity opportunityObj : opportunityRelatedAccountList){
				accountIdsSet.add(opportunityObj.AccountId);

				if(!accountIdsVsOpportunityListMap.containsKey(opportunityObj.AccountId)){
					accountIdsVsOpportunityListMap.put(opportunityObj.AccountId, new List<Opportunity>());
				}
				accountIdsVsOpportunityListMap.get(opportunityObj.AccountId).add(opportunityObj);
			}
		}

		if(accountIdsSet.size() > 0){
			for(Id acctId : accountIdsSet){
				if(!accountIdVsContactListOpportunityListMap.containsKey(acctId)){
					accountIdVsContactListOpportunityListMap.put(acctId, new Map<List<Contact>, List<Opportunity>>());
				}
				accountIdVsContactListOpportunityListMap.get(acctId).put(accountIdsVsContactListMap.get(acctId), accountIdsVsOpportunityListMap.get(acctId));
			}
		}
		if(!accountIdVsContactListOpportunityListMap.isEmpty()){
			system.debug('accountIdVsContactListOpportunityListMap-- AC :: ' + accountIdVsContactListOpportunityListMap);
		}

	}
}