public class AuraLightningHomeController {

    @AuraEnabled
    public static List<Questions__c> getAllQuestionList_Apex (Boolean isBatch, Boolean isScript, Boolean isTrigger) {
        List<Questions__c> questionList = new List<Questions__c>();
        try {
            String questionQuery = '';
            String fieldsName = AuraLightningHomeController.getFieldsName_Apex('Questions__c');
            if(isBatch) {
                questionQuery = 'SELECT ' + fieldsName + ', Owner.Name FROM Questions__c WHERE Is_Batch__c =: isBatch LIMIT 9999 ';
            } else if(isScript) {
                questionQuery = 'SELECT ' + fieldsName + ', Owner.Name FROM Questions__c WHERE Is_Script__c =: isScript LIMIT 9999 ';
            } else if(isTrigger) {
                questionQuery = 'SELECT ' + fieldsName + ', Owner.Name FROM Questions__c WHERE Is_Trigger__c =: isTrigger LIMIT 9999 ';
            }
            questionList = Database.query(questionQuery);
        } catch (Exception e) {
                System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method getRecordType  ' + e.getMessage());
        }
        return questionList;
    }
    @AuraEnabled
    public static List<Lightning_Tutorials__c> getAllTutorialList_Apex (String lightningTutorialId) {
        List<Lightning_Tutorials__c> lightningTutorialsList = new List<Lightning_Tutorials__c>();
        try {
            String tutorialQuery = '';
            String fieldsName = AuraLightningHomeController.getFieldsName_Apex('Lightning_Tutorials__c');
            if(String.isNotBlank(lightningTutorialId)) {
                tutorialQuery = 'SELECT ' + fieldsName + ', Owner.Name FROM Lightning_Tutorials__c WHERE Id =: lightningTutorialId LIMIT 1 ';
            } else {
                tutorialQuery = 'SELECT ' + fieldsName + ', Owner.Name FROM Lightning_Tutorials__c ORDER BY CreatedDate desc LIMIT 9999 ';
            }           
            lightningTutorialsList = Database.query(tutorialQuery);
        } catch (Exception e) {
                System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method getRecordType  ' + e.getMessage());
        }
        return lightningTutorialsList;
    }
    
    @AuraEnabled
    public static wrapperForTutorials getFinalAllTutorialList_Apex (Integer limits, Integer offsets) {
        wrapperForTutorials wrap = new wrapperForTutorials();
        try {
            List<Lightning_Tutorials__c> lightningTutorialsList = new List<Lightning_Tutorials__c>();
            List<Lightning_Videos__c> lightningVideoTutorialsList = new List<Lightning_Videos__c>();
            String tutorialQuery = '';
            String fieldsName = AuraLightningHomeController.getFieldsName_Apex('Lightning_Tutorials__c');
            tutorialQuery = 'SELECT ' + fieldsName + ', Owner.Name FROM Lightning_Tutorials__c ORDER BY CreatedDate desc LIMIT : limits Offset :  offsets';
            lightningTutorialsList = Database.query(tutorialQuery);
            
            String tutorialVideoQuery = '';
            String videoFieldsName = AuraLightningHomeController.getFieldsName_Apex('Lightning_Videos__c');
            tutorialVideoQuery = 'SELECT ' + videoFieldsName + ', Owner.Name FROM Lightning_Videos__c ORDER BY CreatedDate desc LIMIT 9999 ';
            lightningVideoTutorialsList = Database.query(tutorialVideoQuery);
            
            
            wrap.tutorialList = lightningTutorialsList;
            wrap.videoTutorialList = lightningVideoTutorialsList;
            
        } catch (Exception e) {
                System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method getRecordType  ' + e.getMessage());
        }
        return wrap;
    }
    
    public class wrapperForTutorials {
        @AuraEnabled
        public List<Lightning_Tutorials__c> tutorialList {set; get;}
        @AuraEnabled
        public List<Lightning_Videos__c> videoTutorialList {set; get;}
    }
    
    
    public static String getFieldsName_Apex (String sObjectName) {
        String allFieldsName = '';
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(sObjectName).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values()) {
            schema.describefieldresult dfield = sfield.getDescribe();
            allFieldsName = allFieldsName + dfield.getname() + ', ';
        }
        allFieldsName = allFieldsName.removeEnd(', ');
        return allFieldsName;
    }
    public static String GetUserIPAddress() {
        String getIpAddress = '';
        String userType = UserInfo.getUserType();
        if(userType.equals('Guest')) {
            getIpAddress = MakeRequestForIpAddress.oauthLogin();
            return getIpAddress;
        } else {
            String ip = Auth.SessionManagement.getCurrentSession().get('SourceIp'); //'27.6.222.43';
            system.debug(ip);
            return ip;
        }
        
    }
    public static List<JSON2ApexToGetLocationDetails> getLocationFromIP_Apex (String ip) {
        List<JSON2ApexToGetLocationDetails> wrapList = new List<JSON2ApexToGetLocationDetails>();
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('http://api.ipstack.com/'+ip+'?access_key=ac0fc8f458f776b78c050bb3214b11dc');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            // If the request is successful, parse the JSON response.
            if (response.getStatusCode() == 200) {
                system.debug(response);
                system.debug(response.getBody());
                String responseString = '[' + String.valueOf(response.getBody()) + ']';
                wrapList = (List<JSON2ApexToGetLocationDetails>)System.JSON.deserialize(responseString, List<JSON2ApexToGetLocationDetails>.class);
                system.debug('wrapList ::::::: ' + wrapList);
                system.debug('wrapList ::::::: ' + wrapList[0].country_name);
            }
        } catch (Exception e) {
            system.debug('Error is : ' + e.getMessage() + ' Due to :: ' + e.getLineNumber());
        }
        return wrapList;
    }
    @AuraEnabled
    public static Location_Storage__c addRecordToHitLike_Apex(String lookupOfTutorial) {
        Location_Storage__c location_object = new Location_Storage__c();
        List<Location_Storage__c> location_storage_list = new List<Location_Storage__c>();
        try {
            String ip = AuraLightningHomeController.GetUserIPAddress();
            location_storage_list = [SELECT Id, Name, Ip__c, Lightning_Tutorials__c, CreatedDate FROM Location_Storage__c WHERE Ip__c =: ip AND Lightning_Tutorials__c =: lookupOfTutorial AND CreatedDate = TODAY];
            if(location_storage_list.size() > 0) {
                location_object = location_storage_list[0];
            } else {
                List<JSON2ApexToGetLocationDetails> wrapListTemp = new List<JSON2ApexToGetLocationDetails>();
                List<Location> location_list = new List<Location>();
                wrapListTemp = AuraLightningHomeController.getLocationFromIP_Apex(ip);
                system.debug('wrapListTemp-->>> ' + wrapListTemp);
                location_object.Name = wrapListTemp[0].country_name;
                location_object.Lightning_Tutorials__c = lookupOfTutorial;
                //location_list = wrapListTemp[0].location;
                //location_object.State__c = location_list[0].capital;
                location_object.City__c = wrapListTemp[0].city;
                location_object.Ip__c = AuraLightningHomeController.GetUserIPAddress();
                insert location_object;
            }
            system.debug(location_object);
        } catch (Exception e) {
            system.debug('Error is : ' + e.getMessage() + ' Due to :: ' + e.getLineNumber());
        }
        return location_object;
    }

    /* Popular Post Section */
    @AuraEnabled
    public static List<Lightning_Tutorials__c> getPopularTutorialList_Apex1 () {
        List<Lightning_Tutorials__c> lightningTutorialsList = new List<Lightning_Tutorials__c>();
        try {
            String tutorialQuery = '';
            String fieldsName = AuraLightningHomeController.getFieldsName_Apex('Lightning_Tutorials__c');
            tutorialQuery = 'SELECT ' + fieldsName + ', Owner.Name FROM Lightning_Tutorials__c  ORDER BY LastViewedDate DESC LIMIT 7';           
            lightningTutorialsList = Database.query(tutorialQuery);
        } catch (Exception e) {
                System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method getRecordType  ' + e.getMessage());
        }
        return lightningTutorialsList;
    }
    @AuraEnabled
    public static wrapperForPopularPostConstructor getPopularTutorialList_Apex() {
        wrapperForPopularPostConstructor wrap = new wrapperForPopularPostConstructor();
        try {
            Integer excellent = 0;
            Integer good = 0;
            Integer average = 0;
            Integer bad = 0;
            Integer totalCommunityView = 0;
            List<Rating__c> ratingList = new List<Rating__c>();
            ratingList = [Select Id, Name, Rate__c From Rating__c LIMIT 50000];
            Integer totalRating = 0;
            totalRating = ratingList.size();
            if(ratingList.size() > 0) {
                for(Rating__c rat : ratingList) {
                    if(rat.Rate__c == 'Excellent') {
                        excellent = excellent + 1;
                    } else if(rat.Rate__c == 'Good') {
                        good = good + 1;
                    } else if(rat.Rate__c == 'Average') {
                        average = average + 1;
                    } else if(rat.Rate__c == 'Bad') {
                        bad = bad + 1;
                    }
				}
            }
            List<Lightning_Tutorials__c> lightningTutorialsListTemp = new List<Lightning_Tutorials__c>();
            String tutorialQuery = '';
            String fieldsName = AuraLightningHomeController.getFieldsName_Apex('Lightning_Tutorials__c');
            tutorialQuery = 'SELECT ' + fieldsName + ', Owner.Name FROM Lightning_Tutorials__c WHERE Is_Popular__c = true ORDER BY LastViewedDate DESC LIMIT 7';           
            lightningTutorialsListTemp = Database.query(tutorialQuery);
            
            List<Contact_Us__c> contactUsList = new List<Contact_Us__c>();
            contactUsList = [SELECT Id, Name, Subject__c FROM Contact_Us__c WHERE Name = 'DO NOT DELETE' LIMIT 1];
            if(contactUsList.size() > 0 && contactUsList[0].Subject__c != null) {
                contactUsList[0].Subject__c = String.valueOf(Integer.valueOf(contactUsList[0].Subject__c) + 1);
                update contactUsList[0];
                totalCommunityView = Integer.valueOf(contactUsList[0].Subject__c);
            }
            wrap.totalCommunityView = totalCommunityView;
            
            wrap.lightningTutorialsList = lightningTutorialsListTemp;
            wrap.totalRating = totalRating;
            wrap.totalExcellent = excellent;
            wrap.totalGood = good;
            wrap.totalAverage = average;
            wrap.totalBad = bad;
        } catch (Exception e) {
                System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method getRecordType  ' + e.getMessage());
        }
        return wrap;
    }
    
    public class wrapperForPopularPostConstructor {
        @AuraEnabled
        public List<Lightning_Tutorials__c> lightningTutorialsList {set; get;}
        @AuraEnabled
        public Integer totalRating {set; get;}
        @AuraEnabled
        public Integer totalExcellent {set; get;}
        @AuraEnabled
        public Integer totalGood {set; get;}
        @AuraEnabled
        public Integer totalAverage {set; get;}
        @AuraEnabled
        public Integer totalBad {set; get;}
        @AuraEnabled
        public Integer totalCommunityView {set; get;}
    }
    
    
    /* Post a Rating */
    @AuraEnabled
    public static String addRatingFeedback_Apex(String userName, String email, String url, String rate, String description) {
        try{
            if(String.isNotBlank(userName) && String.isNotBlank(email) && String.isNotBlank(url) && String.isNotBlank(rate)) {
                Rating__c rating = new Rating__c();
                rating.Name = userName;
                rating.Email__c = email;
                rating.Url__c = url;
                rating.Rate__c = rate;
                rating.Description__c = description;
                insert rating;
                return 'success';
            }
        } catch(Exception Ex) {
            System.debug('Error is :: ' + Ex.getMessage() + ' Due to ' + Ex.getLineNumber());
        }
        return null;
    }
}