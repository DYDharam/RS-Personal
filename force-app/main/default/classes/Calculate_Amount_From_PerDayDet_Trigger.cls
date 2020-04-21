public with sharing class Calculate_Amount_From_PerDayDet_Trigger {
    public static void Calculate_Amount_From_PerDayDet(list<Per_Day_Details__c> per_day_details_list)
    {
        list<Customer__c> customer_list = new list<Customer__c>();
        customer_list = [select Id, Name, Rate__c, status__c from Customer__c WHERE status__c = true];
        list<Per_Day_Details__c> perDay_list = new list<Per_Day_Details__c>();
        for(Customer__c cus : customer_list)
        {
            for(Per_Day_Details__c pdt : per_day_details_list)
            {
                if(cus.Id == pdt.Customer__c)
                {
                    pdt.Amount__c = Decimal.valueOf(pdt.Quantity__c) * cus.Rate__c;
                }
            }
        }
    }
}