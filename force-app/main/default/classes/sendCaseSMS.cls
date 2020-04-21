// Class to send SMS from Salesforce using Twilio Helper Libraries
public class sendCaseSMS {

   @Future(callout = true)
   public static void callSMSService(Set<ID> caseIDs)
   {
    List<Case> newCases = [Select Id, ContactId, ContactMobile, CaseNumber, Subject from Case Where ID in :caseIDs] ;
    for (Case c : newCases){

         // Replace the Account & Token below with your Twilio Account & Token IDs
         // In an actual implementation, these values should be stored in custom settings/metadata and not
         // hardcoded in the class itself
         String account = 'ACc60218de6700ac7eaf965b0147eba33a';
         String token = 'd612ce9eede4cfa36211c64e44cf192b';
         TwilioRestClient client = new TwilioRestClient(account, token);
         
         Map<String,String> params = new Map<String,String> {
             'To'   => c.ContactMobile,
             'From' => '<Insert Your Twilio Phone Number Here>',                // Replace with the number given by Twilio
             'Body' => 'Case No.: ' + c.CaseNumber + ' has been logged for ' + c.Subject
         };

         TwilioSMS sms = client.getAccount().getSMSMessages().create(params);
         System.Debug('TwilioSMS ' + sms) ;
         
         // Store the SMS as an activity on Case record. For simplicity sake, this is not bulkified
         Task newTask = new Task();
         newTask.WhatId = c.id;
         newTask.WhoId = c.ContactId;
         newTask.Subject = 'Sent Case Creation SMS';
         newTask.priority= 'Normal' ;
         newTask.status = 'Completed';
         newTask.description = string.valueOf(sms) ;
         newTask.ActivityDate = System.today() ;
         insert newtask;
   }
  }
}