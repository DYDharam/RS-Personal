trigger sendEmailOnRatingTrigger on Rating__c (after insert) {
    if(trigger.isAfter && trigger.isInsert) {
        if(SendMailToRatedUserHelper.isRunOnce == false) {
            sendEmailOnRatingHandler.sendEmailOnRateBtUser(Trigger.New);
        }
    }
}