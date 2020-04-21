public class LightningHomeController {
	//
	@AuraEnabled
	public static String updateSocialCount_Apex(String userId, String socialType) {
		try {
			User usr = new User();
			Contact contactObject = new Contact();
			if(String.isNotBlank(userId) && String.isNotBlank(socialType)) {
				usr = [Select Id, ContactId, Name, Blogger_Url__c, Facebook_Url__c, Facebook_View__c, Google_Plus_Url__c, Linkedin_Url__c, Twitter_Url__c, Google_Plus_View__c, Twitter_View__c, Linkedin_View__c, Blogger_View__c From User Where Id =: userId LIMIT 1];
				String contactId = usr.ContactId;
				contactObject = [SELECT Id, Name, Facebook__c, Google_Plus__c, Twitter__c, Linkedin__c, Blogger__c FROM Contact WHERE Id =: contactId];
				if(String.isNotBlank(contactObject.Id)) {
					if(socialType == 'facebook') {
						if(contactObject.Facebook__c != null) {
							contactObject.Facebook__c = contactObject.Facebook__c + 1;
						} else {
							contactObject.Facebook__c = 1;
						}
					}
					if(socialType == 'google-plus') {
						if(contactObject.Google_Plus__c != null) {
							contactObject.Google_Plus__c = contactObject.Google_Plus__c + 1;
						} else {
							contactObject.Google_Plus__c = 1;
						}
					}
					if(socialType == 'twitter') {
						if(contactObject.Twitter__c != null) {
							contactObject.Twitter__c = contactObject.Twitter__c + 1;
						} else {
							contactObject.Twitter__c = 1;
						}
					}
					if(socialType == 'linkedin') {
						if(contactObject.Linkedin__c != null) {
							contactObject.Linkedin__c = contactObject.Linkedin__c + 1;
						} else {
							contactObject.Linkedin__c = 1;
						}
					}
					if(socialType == 'blogger') {
						if(contactObject.Blogger__c != null) {
							contactObject.Blogger__c = contactObject.Blogger__c + 1;
						} else {
							contactObject.Blogger__c = 1;
						}
					}
					update contactObject;
					return 'success';
				}
			}
		} catch (Exception e) {
			throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage());
		}
		return null;
	}

	@AuraEnabled
	public static void sendMailMethod(String mMail ,String mSubject ,String mbody){
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<String> sendTo = new List<String>();
		sendTo.add(mMail);
		mail.setToAddresses(sendTo);
		mail.setReplyTo('noreply@gmail.com');
		mail.setSenderDisplayName('salesforce User');
		mail.setSubject(mSubject);
		mail.setHtmlBody(mbody);
		mails.add(mail);
		Messaging.sendEmail(mails);
	}
    @AuraEnabled
    public static List<Question__c> saveQuestionDetails_Apex (String questionName, String optionAnswerList) {
        try {
			List<Question__c> questionLists = new List<Question__c>();
            List<Answer__c> answerList = new List<Answer__c>();
            answerList = (List<Answer__c>)System.JSON.deserialize(optionAnswerList, List<Answer__c>.class);
            Question__c questionObject = new Question__c();
            questionObject.Name = questionName;
            insert questionObject;
            for(Answer__c ans : answerList) {
                ans.Question__c = questionObject.Id;
            }
            insert answerList;
			questionLists = [SELECT Id, Name, (SELECT Id, Name, Question__c, isValid__c FROM  Answers__r) From Question__c LIMIT 9999];
			return questionLists;
        } catch (Exception e) {
            System.debug('Get exception on line number ' + e.getLineNumber() + '   due to following method   ' + e.getMessage());
            throw new AuraHandledException('Oops! Something went wrong: ' + e.getMessage() + e.getLineNumber());
        }
    }
}