public class JSON2ApexToGetLocationDetails {

	public String ip {get;set;} 
	public String type_Z {get;set;} // in json: type
	public String continent_code {get;set;} 
	public String continent_name {get;set;} 
	public String country_code {get;set;} 
	public String country_name {get;set;} 
	public String region_code {get;set;} 
	public String region_name {get;set;} 
	public String city {get;set;} 
	public String zip {get;set;} 
	public Double latitude {get;set;} 
	public Double longitude {get;set;} 
	public Location location {get;set;} 

	public JSON2ApexToGetLocationDetails(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'ip') {
						ip = parser.getText();
					} else if (text == 'type') {
						type_Z = parser.getText();
					} else if (text == 'continent_code') {
						continent_code = parser.getText();
					} else if (text == 'continent_name') {
						continent_name = parser.getText();
					} else if (text == 'country_code') {
						country_code = parser.getText();
					} else if (text == 'country_name') {
						country_name = parser.getText();
					} else if (text == 'region_code') {
						region_code = parser.getText();
					} else if (text == 'region_name') {
						region_name = parser.getText();
					} else if (text == 'city') {
						city = parser.getText();
					} else if (text == 'zip') {
						zip = parser.getText();
					} else if (text == 'latitude') {
						latitude = parser.getDoubleValue();
					} else if (text == 'longitude') {
						longitude = parser.getDoubleValue();
					} else if (text == 'location') {
						location = new Location(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2ApexToGetLocationDetails consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Languages {
		public String code {get;set;} 
		public String name {get;set;} 
		public String native {get;set;} 

		public Languages(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'code') {
							code = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'native') {
							native = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Languages consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Location {
		public Integer geoname_id {get;set;} 
		public String capital {get;set;} 
		public List<Languages> languages {get;set;} 
		public String country_flag {get;set;} 
		public String country_flag_emoji {get;set;} 
		public String country_flag_emoji_unicode {get;set;} 
		public String calling_code {get;set;} 
		public Boolean is_eu {get;set;} 

		public Location(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'geoname_id') {
							geoname_id = parser.getIntegerValue();
						} else if (text == 'capital') {
							capital = parser.getText();
						} else if (text == 'languages') {
							languages = arrayOfLanguages(parser);
						} else if (text == 'country_flag') {
							country_flag = parser.getText();
						} else if (text == 'country_flag_emoji') {
							country_flag_emoji = parser.getText();
						} else if (text == 'country_flag_emoji_unicode') {
							country_flag_emoji_unicode = parser.getText();
						} else if (text == 'calling_code') {
							calling_code = parser.getText();
						} else if (text == 'is_eu') {
							is_eu = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Location consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static JSON2ApexToGetLocationDetails parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new JSON2ApexToGetLocationDetails(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	

    private static List<Languages> arrayOfLanguages(System.JSONParser p) {
        List<Languages> res = new List<Languages>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Languages(p));
        }
        return res;
    }
}