trigger Update_Stock_From_StockDetails on Stock_Details__c (before insert) {
    if((Trigger.isBefore && Trigger.isInsert)){
        Update_Stock_From_StockDetails_Trigger.Update_Stock_From_StockDetails(Trigger.new);
    }
}