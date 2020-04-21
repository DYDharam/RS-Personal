public class SendMailToRatedUserHelper {
    public static Boolean isRunOnce = false;
    public static void sendMailToRatedUserWithLink(List<Lightning_Tutorials__c> lightningTutorialList) {
        List<String> sendEmailList = new List<String>();
        List<Rating__c> ratingList = new List<Rating__c>();
        ratingList = [SELECT Id, Name, Email__c FROM Rating__c LIMIT 10000];
        if(!ratingList.isEmpty()) {
            for(Rating__c rating : ratingList) {
                sendEmailList.add(rating.Email__c);
            }
        }
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        if(!lightningTutorialList.isEmpty()) {
            for(Lightning_Tutorials__c tutorials : lightningTutorialList) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(sendEmailList);
                email.setReplyTo('noreply@gmail.com');
                email.setSenderDisplayName('Aura Lightning');
                email.setSubject('New post on Aura Lightning');
                //email.setHtmlBody('https://auralightning-developer-edition.ap5.force.com/s/view?Id=' + tutorials.Id);
                email.setHtmlBody('https://auralightning.wordpress.com/2019/08/29/lightning-datatable-their-features/');
                emailList.add(email);
            }
            Messaging.sendEmail(emailList);
        }   
    }
}