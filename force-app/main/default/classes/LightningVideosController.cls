/**
 * Created by DY DHARAM on 1/Jan/2019.
 */
public class LightningVideosController {




    @AuraEnabled
    public static LightningTutorialsWrapper getLightningTutorials_Apex() {
        LightningTutorialsWrapper ltw = new LightningTutorialsWrapper();
        List<User> usrList = new List<User>();
        List<Contact> contactList = new List<Contact>();
        List<User> usersList = new List<User>();
        List<Lightning_Videos__c> videoList = new List<Lightning_Videos__c>();
        List<Lightning_Tutorials__c> tutorialsList = new List<Lightning_Tutorials__c>();

        List<Question__c> questionLists = new List<Question__c>();
        List<Answer__c> answerList = new List<Answer__c>();


        Set<Id> questionSetIds = new Set<Id>();
        Map<String, List<Answer__c>> questionVsAnswersMap = new Map<String, List<Answer__c>>();
        try {
			Id profileId=userinfo.getProfileId();
			String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
			system.debug('profileName-- >>>> ' + profileName);
            usrList = [SELECT Id, Name, ProfileId, Profile.Name, UserRole.Name FROM User where Profile.Name != 'Lightning Profile' AND Id =: userInfo.getUserId() LIMIT 1];
            if(usrList.size() > 0) {
                ltw.userInfo = usrList[0];
            }

            usersList = [SELECT Id, Name, Email, Facebook_Url__c, Contact.Facebook__c, Contact.Google_Plus__c, Contact.Twitter__c, Contact.Linkedin__c, Contact.Blogger__c, ProfileId, FullPhotoUrl, SmallPhotoUrl, Profile.Name, UserRole.Name FROM User WHERE Profile.Name = 'DYCommunity'  ORDER BY Name asc];
            if(usersList.size() > 0) {
                ltw.userList = usersList;
            }

            contactList = [select Id, Name, Facebook__c, Google_Plus__c, Twitter__c, Linkedin__c, Blogger__c FROM Contact WHERE LastName = 'Social Visitors'];
            if(contactList.size() > 0) {
                ltw.contactInfo = contactList[0];
            }

            videoList = [SELECT Id, Name, Video_Url__c, Image_Url__c, Description__c, Owner.Name, CreatedBy.FullPhotoUrl FROM Lightning_Videos__c order by LastModifiedDate desc LIMIT 50000];
            if(videoList.size() > 0) {
                ltw.lightningVideoList = videoList;
            }

            tutorialsList = [SELECT Id, Name, Description__c, Component_Name__c, Component_Description__c, Visualforce_Description__c, App_Description__c, Design_Description__c, Class_Description__c, Controller_Description__c, Documentation_Description__c, Event_Description__c, Helper_Description__c, Renderer_Description__c, Style_Description__c, Svg_Description__c, Image_Url__c, Owner.Name, CreatedBy.FullPhotoUrl FROM Lightning_Tutorials__c  order by LastModifiedDate desc LIMIT 50000];
            if(tutorialsList.size() > 0) {
                ltw.lightningTutorialList = tutorialsList;
            }

            questionLists = [SELECT Id, Name, (SELECT Id, Name, Question__c, isValid__c FROM  Answers__r) From Question__c LIMIT 9999];
            if(questionLists.size() > 0) {
                ltw.questionsList = questionLists;
            }
            String getUserId = UserInfo.getUserId();
            system.debug('getUserId-->>> '+getUserId);
            Integer totalPostContribution = 0;
            totalPostContribution = database.countQuery('select count() from Lightning_Tutorials__c WHERE OwnerId =: getUserId');
            system.debug('totalPostContribution-->>> '+totalPostContribution);
            ltw.totalPostContribution = totalPostContribution;

        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return ltw;
    }

    public Class LightningTutorialsWrapper {
        @AuraEnabled
        public User userInfo {set; get;}
        @AuraEnabled
        public Contact contactInfo {set; get;}
        @AuraEnabled
        List<User> userList {set; get;}
        @AuraEnabled
        public List<Lightning_Videos__c> lightningVideoList {set; get;}
        @AuraEnabled
        List<Lightning_Tutorials__c> lightningTutorialList {set; get;}
        @AuraEnabled
        List<Question__c> questionsList {set; get;}
        @AuraEnabled
        Integer totalPostContribution {set; get;}
    }








    @AuraEnabled
    public static Contact updateSocialType_Apex(String socialType) {
        List<Contact> contactList = new List<Contact>();
        try {
            if(String.isNotBlank(socialType)) {
                contactList = [SELECT Id, Name, Facebook__c, Google_Plus__c, Twitter__c, Linkedin__c, Blogger__c FROM Contact WHERE LastName = 'Social Visitors'];
                if(contactList.size() > 0) {
                    if(socialType == 'Facebook') {
                        if(contactList[0].Facebook__c != null) {
                            contactList[0].Facebook__c = contactList[0].Facebook__c + 1;
                        } else {
                            contactList[0].Facebook__c = 1;
                        }

                    } else if(socialType == 'Google Plus') {
                        if(contactList[0].Google_Plus__c != null) {
                            contactList[0].Google_Plus__c = contactList[0].Google_Plus__c + 1;
                        } else {
                            contactList[0].Google_Plus__c = 1;
                        }
                    } else if(socialType == 'Twitter') {
                        if(contactList[0].Twitter__c != null) {
                            contactList[0].Twitter__c = contactList[0].Twitter__c + 1;
                        } else {
                            contactList[0].Twitter__c = 1;
                        }
                    } else if(socialType == 'Linkedin') {
                        if(contactList[0].Linkedin__c != null) {
                            contactList[0].Linkedin__c = contactList[0].Linkedin__c + 1;
                        } else {
                            contactList[0].Linkedin__c = 1;
                        }
                    } else if(socialType == 'Blogger') {
                        if(contactList[0].Blogger__c != null) {
                            contactList[0].Blogger__c = contactList[0].Blogger__c + 1;
                        } else {
                            contactList[0].Blogger__c = 1;
                        }
                    }
                }
            }
            if(contactList.size() > 0) {
                update contactList[0];
                return contactList[0];
            } else {
                Contact contacts = new Contact();
                contacts.FirstName = 'Social Visitors';
                contacts.LastName = 'Social Visitors';
                if(socialType == 'Facebook') {
                    contacts.Facebook__c = 1;
                } else if(socialType == 'Google Plus') {
                    contacts.Google_Plus__c = 1;
                }  else if(socialType == 'Twitter') {
                    contacts.Twitter__c = 1;
                }  else if(socialType == 'Linkedin') {
                    contacts.Linkedin__c = 1;
                }  else if(socialType == 'Blogger') {
                    contacts.Blogger__c = 1;
                }
                insert contacts;
                return contacts;
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        //return null;
    }

    @AuraEnabled
    public static List<Lightning_Videos__c> getLightningList_Apex() {
        List<Lightning_Videos__c> videoList = new List<Lightning_Videos__c>();
        try {
            videoList = [SELECT Id, Name, Video_Url__c, Image_Url__c, Description__c, Owner.Name FROM Lightning_Videos__c order by LastModifiedDate desc LIMIT 50000];
            if(videoList.size() > 0) {
                return videoList;
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return null;
    }
    @AuraEnabled
    public static List<Lightning_Tutorials__c> getLightningTutorialsList_Apex() {
        List<Lightning_Tutorials__c> tutorialsList = new List<Lightning_Tutorials__c>();
        try {
            tutorialsList = [SELECT Id, Name, Component_Name__c, Description__c, Component_Description__c, Visualforce_Description__c, App_Description__c, Design_Description__c, Class_Description__c, Controller_Description__c, Documentation_Description__c, Event_Description__c, Helper_Description__c, Renderer_Description__c, Style_Description__c, Svg_Description__c, Image_Url__c, Owner.Name FROM Lightning_Tutorials__c  order by LastModifiedDate desc LIMIT 50000];
            if(tutorialsList.size() > 0) {
                return tutorialsList;
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return null;
    }
    @AuraEnabled
    public static User fetchUser() {
        try {
            List<User> usrList = [SELECT Id, Name, ProfileId, Profile.Name, UserRole.Name FROM User where Profile.Name != 'Lightning Profile' AND Id =: userInfo.getUserId() LIMIT 1];
            system.debug('usrList-->>'+usrList);
            if(usrList.size() > 0) {
                return usrList[0];
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return null;
    }
    @AuraEnabled
    public static String saveLightningRecord_Apex(Lightning_Videos__c createLightningRecord) {
        try {
            if(String.isNotBlank(createLightningRecord.Name)) {
                insert createLightningRecord;
                return 'success';
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return null;
    }
    @AuraEnabled
    public static String saveLightningTutorialRecord_Apex(Lightning_Tutorials__c createLightningRecord) {
        try {
            if(String.isNotBlank(createLightningRecord.Name)) {
                insert createLightningRecord;
                return 'success';
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return null;
    }
    @AuraEnabled
    public static String deleteLightningRecord_Apex(String deleteRecordId, String sObjectName) {
        List<Lightning_Videos__c> lightningList = new List<Lightning_Videos__c>();
        List<Lightning_Tutorials__c> lightningsList = new List<Lightning_Tutorials__c>();
        try {
            if(String.isNotBlank(deleteRecordId) && sObjectName == 'Lightning_Videos__c') {
                lightningList = [SELECT Id FROM Lightning_Videos__c WHERE Id =: deleteRecordId LIMIT 1];
                if(lightningList.size() > 0) {
                    delete lightningList;
                    return 'success';
                }
            } else if(String.isNotBlank(deleteRecordId) && sObjectName == 'Lightning_Tutorials__c') {
                lightningsList = [SELECT Id FROM Lightning_Tutorials__c WHERE Id =: deleteRecordId LIMIT 1];
                if(lightningsList.size() > 0) {
                    delete lightningsList;
                    return 'success';
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return null;
    }
    /*
    Method Name : createContactUsRecord
    Purpose     : To save the Contact-Us Record into the apex class.
    */
    @AuraEnabled
    public static Contact_Us__c createContactUsRecord(Contact_Us__c contactUsRecord) {
        try {
            if(contactUsRecord != null) {
                insert contactUsRecord;
                return contactUsRecord;
            }
        } catch (Exception e) {
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
        }
        return null;
    }
}