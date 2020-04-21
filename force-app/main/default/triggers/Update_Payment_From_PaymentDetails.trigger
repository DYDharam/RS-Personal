trigger Update_Payment_From_PaymentDetails on Payment_Details__c (before insert) {
    if((Trigger.isBefore && Trigger.isInsert)){
        Update_Payment_From_PayDetails_Trigger.Update_Payment_From_PayDetails(Trigger.new);
    }
}