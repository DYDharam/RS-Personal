public class EmailSendController {

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

}