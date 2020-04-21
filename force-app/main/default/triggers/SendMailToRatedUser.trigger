trigger SendMailToRatedUser on Lightning_Tutorials__c (after insert) {
    if(trigger.isAfter && trigger.isInsert) {
        if(SendMailToRatedUserHelper.isRunOnce == false) {
            SendMailToRatedUserHelper.isRunOnce = true;
            //SendMailToRatedUserHelper.sendMailToRatedUserWithLink(trigger.new);
        }
    }
    if(trigger.isAfter && trigger.isUpdate) {
        if(SendMailToRatedUserHelper.isRunOnce == false) {
            SendMailToRatedUserHelper.isRunOnce = true;
            SendMailToRatedUserHelper.sendMailToRatedUserWithLink(trigger.new);
        }
    }
}