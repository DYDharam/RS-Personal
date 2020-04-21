public class sendEmailOnRatingHandler {
    public static Boolean isRunOnce = false;
    public static void sendEmailOnRateBtUser(List<Rating__c> ratingList) {
        List<String> emailList = new List<String>();
        for(Rating__c ratingObject : ratingList) {
            emailList.add(ratingObject.Email__c);
		}
        system.debug('emailList::: ' + emailList);
        List<Messaging.SingleEmailMessage> sendEmailList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();
        singleEmail.setToAddresses(emailList);
        singleEmail.setCcAddresses(new String[] {'infodharmendra2020@gmail.com'});
        singleEmail.setReplyTo('noreply@gmail.com');
        singleEmail.setSenderDisplayName('Aura Lightning');
        singleEmail.setSubject('Thanks for Rating us.');
        singleEmail.setHtmlBody('You can visit our community: <a href="http://auralightning-developer-edition.ap5.force.com">Click Here </a>');
        sendEmailList.add(singleEmail);
        Messaging.sendEmail(sendEmailList);
    }
}