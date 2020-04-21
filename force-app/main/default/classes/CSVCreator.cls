/*
 * Created by DY DHARAM on 11-12-2019.
 */
public class CSVCreator  {

	private static List<String> separateCommas(String input){
		List<String> results = input.split(',');

		for(String result : results) {
			result = result.trim();
		}

		return results;
	}

	@AuraEnabled
	public static CSVObject getCSVObject(String csv_str) {
		List<String> lines_raw = csv_str.split('\n');
		List<String> headers_raw = separateCommas(lines_raw[0]);
		List<List<String>> lines = new List<List<String>>();
		List<CSVHeader> headers = new List<CSVHeader>();

		lines_raw.remove(0);

		//Handling fields with commas

		for(String line : lines_raw) {
			List<String> line_sep = separateCommas(line);
			List<String> fields = new List<String>();
			Boolean makeCompositeField = false;
			String compositeField;
			for(String field : line_sep) {
				system.debug('field>>> ' + field);
				if(String.isNotBlank(field) && field != null) {
					if (field.startsWith('"') && field.endsWith('"')) {
						fields.add(field.trim());
					} else if (field.startsWith('"')) {
						makeCompositeField = true;
						compositeField = field;
					} else if (field.endsWith('"')) {
						compositeField += ',' + field;
						system.debug('compositeField::>> ' + compositeField);
						fields.add(compositeField.trim());
						makeCompositeField = false;
					} else if (makeCompositeField) {
						compositeField +=  ',' + field;
					} else {
						fields.add(field.trim());
					}
				}
			}

			lines.add(fields);


			system.debug('lines::>>>>> ' + fields);
		}
		system.debug('lines:::: ' + lines);

		for(String header : headers_raw) {
			if(String.isNotBlank(header) && header != null) {
				headers.add(new CSVHeader(header));
			}

		}
		system.debug('headers:::: ' + headers);
		system.debug('headers:::::::::::: ' + headers);

		return new CSVObject(headers, lines);
	}
    @AuraEnabled
    public static List<Account> insertedAccountListDetails_Apex(List<Account> accountList) {
        //List<Account> accountList = new List<Account>();
        for(Account accounts : accountList) {
            //accounts.SLAExpirationDate__c = Date.parse(accounts.SLAExpirationDate__c);
        }
        insert accountList;
        return accountList;
    }

}