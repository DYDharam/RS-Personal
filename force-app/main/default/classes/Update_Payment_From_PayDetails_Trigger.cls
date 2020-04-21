public class Update_Payment_From_PayDetails_Trigger {
    public static void Update_Payment_From_PayDetails(list <Payment_Details__c> paymentDetails_List)
    {
        list<Payment__c> payment_list = new list<Payment__c>();
        payment_list = [select Id, Name,Customer__c, Dues_Amount__c, Dues_Date__c, Paid_Amount__c,Pay_Status__c from Payment__c  WHERE Pay_Status__c = false ORDER BY Dues_Date__c desc];
        
        list<Payment__c> payment_new_list = new list<Payment__c>();
        if(paymentDetails_List.size()>0)
        {
            for(Payment_Details__c paymentDetails : paymentDetails_List)
            {
                Decimal pamt = paymentDetails.Paid_Amount__c;
                for(Payment__c payment : payment_list)
                {
                    if(payment.Customer__c == paymentDetails.Customer__c)
                    {
                        
                        if((pamt) > payment.Dues_Amount__c)
                        {
                            system.debug('------>>>>----->>>>>');
                            pamt = pamt - payment.Dues_Amount__c;
                            Payment__c p = new Payment__c();
                            p.Id = payment.Id;
                            p.Pay_Status__c = true;
                            payment_new_list.add(p);
                        }
                        else if((payment.Dues_Amount__c) > pamt)
                        {
                            Decimal damt = payment.Dues_Amount__c;
                            system.debug('------>>>>-ELSE---->>>>>');
                            damt = damt - pamt;
                            pamt =0;
                            Payment__c p = new Payment__c();
                            p.Id = payment.Id;
                            p.Pay_Status__c = false;
                            p.Dues_Amount__c = damt;
                            payment_new_list.add(p);
                        }
                        else if((payment.Dues_Amount__c) == pamt)
                        {
                            Decimal damt = payment.Dues_Amount__c;
                            system.debug('------>>>>-ELSE---->>>>>');
                            damt = damt - pamt;
                            pamt =0;
                            Payment__c p = new Payment__c();
                            p.Id = payment.Id;
                            p.Pay_Status__c = true;
                            p.Dues_Amount__c = payment.Dues_Amount__c;
                            payment_new_list.add(p);
                        }
                    }
                }
            }
            if(payment_new_list.size()>0)
            {
                update payment_new_list;
            }
        }
    }
}