global class Per_Day_Use_Product_Batch implements Database.Batchable<sObject>
{    
    //-Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        String stock_list='Select id, Quantity__c, Use_Product_Per_Day__c from Stock__c WHERE Quantity__c > 0';
        return Database.getQueryLocator(stock_list);
    }
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Stock__c> stock_list)
    {
        list<Stock__c> stock_list_update = new list<Stock__c>();
        for(Stock__c stock : stock_list)
        {
            stock.Quantity__c = stock.Quantity__c - stock.Use_Product_Per_Day__c;
            stock_list_update.add(stock);
        }
        if(stock_list_update.size()>0)
        {
            update stock_list_update;
            System.debug('Done');
        }
    }
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
        system.debug('finish batch');
    }
}