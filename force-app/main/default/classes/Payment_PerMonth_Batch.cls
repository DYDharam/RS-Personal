global class Payment_PerMonth_Batch implements Database.Batchable<sObject>{
	global Date myDate;
	global Date myDate2;
    //-Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
    	
    	//Date currentDate = Date.today();
    	//Integer calculateDay = currentDate.day();
    	//Date secondDate = currentDate.addDays(-calculateDay);
		//Date currentDate = Date.valueOf('2017-11-22');
		
		Date currentDate = date.today();
		Integer da = currentDate.day();
		Date lastDate = currentDate.addDays(-da);
		system.debug('lastDate'+lastDate);
		String[] ds = String.valueOf(lastDate).split(' ');
		String[] str = ds[0].split('-');
		string yy = str[0];
		string mm = str[1];
		string dd = str[2];
		system.debug(mm+'-'+dd+'--'+yy);
		String dt = mm+'/'+dd+'/'+yy+' 00:00:00';
		system.debug(dt);
		String[] str12 = dt.split(' ');
		String[] dts = str12[0].split('/');
		myDate = date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
		system.debug('newDte'+myDate);
		//- Last Date of the Month  (END) --//
		System.debug('--------Date1111'+myDate);
		
		//- Start Date of the Month  (Start) --//
		String dt2 = mm+'/01/'+yy+' 00:00:00';
		String[] str22 = dt2.split(' ');
		String[] dts22 = str22[0].split('/');
		myDate2 = date.newinstance(Integer.valueOf(dts22[2]), Integer.valueOf(dts22[0]), Integer.valueOf(dts22[1]));
		system.debug('newDte222'+myDate2);
		//- Start Date of the Month  (END) --//
		
		System.debug('--------Date2222'+myDate2);
		
		/* list<Per_Day_Details__c> per = new list<Per_Day_Details__c>();
		per = [select Id, Name, Date__c from Per_Day_Details__c where Date__c <=: myDate AND Date__c >=: myDate2]; //---- 2017/10/31 (YYYY/MM/DD)   (2017/10/01 (YYYY/MM/DD)
		system.debug('-------Per'+per); */
				

        String perDayDetList='select Id, Name, Date__c, Customer__c, Amount__c, Quantity__c from Per_Day_Details__c where Date__c <=: myDate AND Date__c >=: myDate2'; // where Date__c <=: myDate AND Date__c >=: myDate2
        system.debug('perDayDetList------------->'+perDayDetList);
        return Database.getQueryLocator(perDayDetList);
    }
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Per_Day_Details__c> perDayList)
    {
    	Date currentDate = date.today();
		Integer da = currentDate.day();
		Date lastDate = currentDate.addDays(-da);
		system.debug('lastDate'+lastDate);
		String[] ds = String.valueOf(lastDate).split(' ');
		String[] str = ds[0].split('-');
		string yy = str[0];
		string mm = str[1];
		string dd = str[2];
		system.debug(mm+'-'+dd+'--'+yy);
		String dt = mm+'/'+dd+'/'+yy+' 00:00:00';
		system.debug(dt);
		String[] str12 = dt.split(' ');
		String[] dts = str12[0].split('/');
		myDate = date.newinstance(Integer.valueOf(dts[2]), Integer.valueOf(dts[0]), Integer.valueOf(dts[1]));
		system.debug('newDte'+myDate);
		//- Last Date of the Month  (END) --//
		System.debug('--------Date1111'+myDate);
        
        map<Id, List<Per_Day_Details__c>> perDayListMap = new map<Id, List<Per_Day_Details__c>>();
        List<Per_Day_Details__c> perList = new List <Per_Day_Details__c>();
        perList = [select Id, Name, Date__c, Customer__c, Amount__c, Quantity__c from Per_Day_Details__c ];
        
    	
		list<Customer__c> customer_list = new list<Customer__c>();
		customer_list = [select Id, Name from Customer__c limit 200];
        system.debug('customer_list=--------->'+customer_list);
		
    	system.debug('perDayList-INNNNNNNNNNNNNNNNN------->'+perDayList);
    	if(perDayList.size() > 0)
        {
            Integer allQuntity = 0;
            ID id = null;
            
        	list<Payment__c> paymentList = new list<Payment__c>();
        	
            for(Customer__c cus : customer_list)
	        {
                Integer Amount = 0;
                Payment__c p = new Payment__c();
                p.Customer__c = cus.Id;
                for(Per_Day_Details__c pdd : perDayList)
                {
	        		
	        		if(cus.Id == pdd.Customer__c)
	        		{
                       
                        /* if(pdd.Quantity__c != null) {
                            
                           allQuntity += Integer.valueOf(pdd.Quantity__c);
                            system.debug('>>>allQuntity>>>'+allQuntity);
                        } */
                        if(pdd.Amount__c != null) {
                            
                           Amount += Integer.valueOf(pdd.Amount__c);
                            system.debug('>>>Amount>>>'+Amount);
                        }                  
	        		}	        		
	        	}                   
                	
                p.Dues_Amount__c = Amount;
                p.Dues_Date__c = myDate;
                p.Pay_Status__c = false;
                paymentList.add(p);                	           
	        }
	         system.debug('paymentList----------->'+paymentList);
	        if(paymentList.size() > 0)
	        {
                system.debug('>>>paymentList>>>'+paymentList);
	        	insert paymentList;               
	       
	        } 
        }
    }
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
        system.debug('finish batch');
    }
}
/*
0 0 1 1 1/1 ? *
*/