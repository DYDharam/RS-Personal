public with sharing class Update_Stock_From_StockDetails_Trigger {
    public static void Update_Stock_From_StockDetails(list <Stock_Details__c> stockDetails_List)
    {
    	list<Stock__c> stock_list = new list<Stock__c>();
    	stock_list = [select Id, Name, Quantity__c from Stock__c];
    	
    	list<Stock__c> stock_new_list = new list<Stock__c>();
    	if(stockDetails_List.size()>0)
    	{
    		for(Stock_Details__c stockDetails : stockDetails_List)
    		{
    			for(Stock__c stock : stock_list)
    			{
    				if(stockDetails.Stock__c == stock.Id)
    				{
    					Stock__c sto = new Stock__c();
    					sto.Id = stockDetails.Stock__c;
    					sto.Quantity__c = stock.Quantity__c + stockDetails.Enter_Stock__c;
    					stock_new_list.add(sto);
    					system.debug('---------------->'+stock_new_list);
    				}
    			}
    		}
    		if(stock_new_list.size()>0)
    		{
    			update stock_new_list;
    		}
    	}
    }
}