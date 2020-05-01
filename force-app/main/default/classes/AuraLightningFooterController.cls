public class AuraLightningFooterController {
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
            system.debug('profileName-- ::::>>>> ' + profileName);
            usrList = [SELECT Id, Name, ProfileId, Profile.Name, UserRole.Name FROM User  LIMIT 1];
            if(usrList.size() > 0) {
                ltw.userInfo = usrList[0];
            }
            
            usersList = [SELECT Id, Name, Email, Facebook_Url__c, Contact.Facebook__c, Contact.Google_Plus__c, Contact.Twitter__c, Contact.Linkedin__c, Contact.Blogger__c, ProfileId, FullPhotoUrl, SmallPhotoUrl, Profile.Name, UserRole.Name FROM User  ORDER BY Name asc LIMIT 10];
            if(usersList.size() > 0) {
                ltw.userListInfo = usersList;
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
        List<User> userListInfo {set; get;}
        @AuraEnabled
        public List<Lightning_Videos__c> lightningVideoList {set; get;}
        @AuraEnabled
        List<Lightning_Tutorials__c> lightningTutorialList {set; get;}
        @AuraEnabled
        List<Question__c> questionsList {set; get;}
        @AuraEnabled
        Integer totalPostContribution {set; get;}
    }
}