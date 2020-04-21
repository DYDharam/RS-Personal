/*
 * Created by DY DHARAM on 10-12-2019.
 */
public class CSVFileComponentController {
	@AuraEnabled
	public static String SaveFile(Id parentId, String fileName, String base64Data, String contentType) {
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
		 system.debug('parentId:::: ' + parentId);
		system.debug('fileName:::: ' + fileName);
		system.debug('base64Data:::: ' + base64Data);
		system.debug('contentType:::: ' + contentType);
		String csvString = String.valueOf(base64Data);
		system.debug('csvString;::: ' + csvString);
		String csvAsString  = EncodingUtil.base64Decode(base64Data).toString();
		system.debug('csvAsString :: '  + csvAsString );
		List<String> csvFileLines = csvAsString.split('\n');
		system.debug('csvFileLines::: ' + csvFileLines);
		List<Account> accList = new List<Account>();

		Map<String, Integer> columnNameVsIndexMap = new Map<String, Integer>();
		Integer indexNum = 0;
		List<String> columnList = new List<String>();
		columnList = csvAsString.split(',');
		for(String str : columnList) {
			if(String.isNotBlank(str) && !str.equals(',')) {
				if(!columnNameVsIndexMap.containsKey(str)) {
					system.debug('str:: ' + str);
					system.debug('indexNum:: ' + indexNum);
					columnNameVsIndexMap.put(str, indexNum);
					system.debug('columnNameVsIndexMap:::>> ' + columnNameVsIndexMap);
					indexNum = indexNum + 1;
				}
			}

		}
		system.debug('columnNameVsIndexMap::: ' + columnNameVsIndexMap);


		for(Integer i=1;i<csvFileLines.size();i++){
			Account accObj = new Account() ;
			string[] csvRecordData = csvFileLines[i].split(',');


			if(csvAsString.contains('Name')) {
				accObj.name = csvRecordData[1];
			}
			if(csvAsString.contains('SLA Expiration Date')) {
				//accObj.SLAExpirationDate__c = Date.valueOf(csvRecordData[2]);
			}
			if(csvAsString.contains('Phone')) {
				accObj.Phone = csvRecordData[3];
			}
			if(csvAsString.contains('Description')) {
				accObj.Description = csvRecordData[4];
			}



			/*accObj.name = csvRecordData[0] ;
			accObj.accountnumber = csvRecordData[1];
			accObj.Type = csvRecordData[2];
			accObj.AccountSource = csvRecordData[3];
			accObj.Industry = csvRecordData[4];*/
			system.debug('accObj::: ' + accObj);
			acclist.add(accObj);


		}
		system.debug('acclist:::: ' + acclist);
		system.debug('acclist::: ' + acclist.size());

		/*Attachment attach = new Attachment();
		attach.parentId = parentId;
		attach.Body = EncodingUtil.base64Decode(base64Data);
		attach.Name = fileName;
		attach.ContentType = contentType;
		Insert attach;*/
		return 'success';
	}
}