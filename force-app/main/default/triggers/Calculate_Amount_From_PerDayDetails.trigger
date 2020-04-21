trigger Calculate_Amount_From_PerDayDetails on Per_Day_Details__c (before insert) {
    if((Trigger.isBefore && Trigger.isInsert)){
        Calculate_Amount_From_PerDayDet_Trigger.Calculate_Amount_From_PerDayDet(Trigger.new);
    }
}