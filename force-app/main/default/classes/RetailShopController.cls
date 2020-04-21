public with sharing class RetailShopController {
	
	@AuraEnabled
	public static Account login_Apex_Verifier ()
	{
		Account acc = new Account();
		acc = [select Id, Name, password__c, email__c, active__c from Account WHERE active__c = true LIMIT 1];
		if(acc.id != null)
		{
			return acc;
		}
		return null;
	}
	
    @AuraEnabled
    public static Account loginUser_Apex (String currentUserId)
    {
        Account acc = new Account();
		acc = [select Id, Name, password__c, email__c, active__c from Account WHERE Id =: currentUserId LIMIT 1];
        if(acc.id != null)
		{
			return acc;
		}
		return null;
    }
    
	@AuraEnabled
	public static Account login_Apex (String Email, String Password)
	{
		Account acc = new Account();
		acc = [select Id, Name, password__c, email__c, active__c from Account WHERE email__c =: Email AND password__c =: Password LIMIT 1];
		if(acc.id != null)
		{
			return acc;	
		}
		return null;
	}
	
	@AuraEnabled
	public static List<customer_wrapper_class> getAllWrapper_APEX() {
	try{
		List<customer_wrapper_class> customer_wrapper_classList = new List<customer_wrapper_class>();
		List<Customer__c> customer_List = new List <Customer__c>();
		customer_List = [SELECT Id, Name FROM Customer__c ORDER BY Name asc limit 300];
		for(Customer__c cus: customer_List)
		{
			customer_wrapper_class wrap_obj = new customer_wrapper_class();
			wrap_obj.CustomerId = cus.Id;
            wrap_obj.Name = cus.Name;
            wrap_obj.isDisabled = false;
            wrap_obj.isCash = false;
            wrap_obj.isCashDisable = false;
            wrap_obj.sQuantity = '';
            customer_wrapper_classList.add(wrap_obj);
		}
        return customer_wrapper_classList;
	} catch (Exception ex) {
            String errorString = 'ERROR: ' + ex.getMessage() + ' : ' + ex.getLineNumber();
            System.debug(errorString);
        }
	return null;
    }
    @AuraEnabled
	public static List<Stock_wrapper_class> getAllStock_APEX() {
	try{
		List<Stock_wrapper_class> stock_wrapper_classList = new List<Stock_wrapper_class>();
		List<Stock__c> stock_List = new List <Stock__c>();
		stock_List = [SELECT Id, Name, Quantity__c, Use_Product_Per_Day__c FROM Stock__c ORDER BY Name asc limit 300];
		for(Stock__c sto: stock_List)
		{
			Stock_wrapper_class wrap_obj = new Stock_wrapper_class();
			wrap_obj.Id = sto.Id;
			wrap_obj.StockId = sto.Id;
            wrap_obj.Name = sto.Name;
            wrap_obj.sQuantity = Integer.valueOf(sto.Quantity__c);
            wrap_obj.useProduct = Integer.valueOf(sto.Use_Product_Per_Day__c);
            stock_wrapper_classList.add(wrap_obj);
		}
        return stock_wrapper_classList;
	} catch (Exception ex) {
            String errorString = 'ERROR: ' + ex.getMessage() + ' : ' + ex.getLineNumber();
        }
	return null;
    }
    @AuraEnabled
	public static List<Per_Day_Details__c> savePDD_APEX(String addWrapper, String DateToday) {
		System.debug('------------>addWrapper '+addWrapper);
        String[] str = DateToday.split('/');
        string dd = str[0];
        string mm = str[1];
        string yy = str[2];
        Date selectedDate = date.valueOf(yy+'-'+dd+'-'+mm);
        List<customer_wrapper_class> myList = (List<customer_wrapper_class>)System.JSON.deserialize(addWrapper, List<customer_wrapper_class>.class);
        List<Per_Day_Details__c> pdList = new List<Per_Day_Details__c>();
        for(customer_wrapper_class cwc : myList)
        {
        	if(cwc.sQuantity != '')
        	{
        		Per_Day_Details__c pdd = new Per_Day_Details__c();
	        	pdd.Customer__c =  cwc.CustomerId;
	        	pdd.Date__c = selectedDate;
	        	pdd.Quantity__c = cwc.sQuantity;
	            pdList.add(pdd);
        	}
        	/*else
        	{
        		Per_Day_Details__c pdd = new Per_Day_Details__c();
	        	pdd.Customer__c =  cwc.CustomerId;
	        	pdd.Date__c = selectedDate;
	        	pdd.Quantity__c = '';
	            pdList.add(pdd);
        	}*/
        	
            
        }
        if(pdList.size()>0)
        {
            insert pdList;
            return pdList;
        }
        return null;
    }
    
    @AuraEnabled
    public static List<Stock__c> notification_APEX() {
        return [SELECT Id, Name, Quantity__c FROM Stock__c Where Quantity__c < 100 ORDER BY Name asc]; 
    }
    @AuraEnabled
    public static List<Per_Day_Details__c> showAllDataOfPerDayDetails_APEX(String date1, String date2, String name) {
    	Date d1 = Date.valueOf(date1);
    	Date d2 = Date.valueOf(date2);
    	List<Customer__c> cus = new List<Customer__c>();
    	cus = [Select Id, Name from Customer__c where Name =: name limit 1];
    	List<Per_Day_Details__c> nelist = new List<Per_Day_Details__c>();
        nelist = [SELECT Id, Name, Quantity__c, Date__c, Customer__c, Amount__c, Cash__c FROM Per_Day_Details__c WHERE Date__c >=: d1 and Date__c <=: d2 AND Customer__c =: cus[0].Id];
        return nelist; 
    }
    @AuraEnabled
    public static List<String> recentPerDayDetails_Apex() {
        
    	List<Per_Day_Details__c> nelist = new List<Per_Day_Details__c>();
        nelist = [SELECT Id, Name, Quantity__c, Date__c, Customer__c, Amount__c, Cash__c FROM Per_Day_Details__c ORDER BY Date__c desc LIMIT 50];
        set<String> dateList = new set<String>();
		for(Per_Day_Details__c ss : nelist)
        {
            dateList.add(String.valueOf(ss.Date__c));
        }
        List<String> list1 = new List<String>(dateList);
        return list1; 
    }
	@AuraEnabled
    public static List<Customer__c> AllCustomers() {
        return [SELECT Id, Name, Address__c,Phone__c,Status__c, Rate__c FROM Customer__c ORDER BY Name asc]; 
    }
    @AuraEnabled
    public static List<Stock__c> AllStockDetails() {
        return [SELECT Id, Name, Quantity__c FROM Stock__c ORDER BY Name asc]; 
    }
    @AuraEnabled
    public static String newCustomer_apex(String Name, String Address, String Phone, String Rate){
        system.debug('-->>>Name'+Name);
        system.debug('-->>>Address'+Address);
        system.debug('-->>>Phone'+Phone);
        system.debug('-->>>Rate'+Rate);
    	if(Name != '')
    	{
            List<Customer__c> newCusList = new List<Customer__c>(); 
            
                Customer__c cus = new Customer__c();
                cus.Name = Name;
                cus.Address__c = Address;
                cus.Phone__c = Decimal.valueOf(Phone);
                cus.Rate__c = Decimal.valueOf(Rate);
                cus.status__c = true;
                newCusList.add(cus);
                  
            if(newCusList.size()>0){
                insert newCusList;
                return 'Success';
            }
    		
    	}
    	return null;
    }
    @AuraEnabled
    public static List<Stock_Details__c> AllStockDetailsToSave_Apex(String StockList, String DateToday) {
    	system.debug('-----+++++'+StockList);
        String[] str = DateToday.split('/');
        string dd = str[0];
        string mm = str[1];
        string yy = str[2];
        Date selectedDate = date.valueOf(yy+'-'+dd+'-'+mm);
        List<Stock_wrapper_class> myList = (List<Stock_wrapper_class>)System.JSON.deserialize(StockList, List<Stock_wrapper_class>.class);
        List<Stock_Details__c> pdList = new List<Stock_Details__c>();
        for(Stock_wrapper_class cwc : myList)
        {
        	if(cwc.AddQuantity != Null)
        	{
        		Stock_Details__c pdd = new Stock_Details__c();
	        	pdd.Date__c =  selectedDate;
	        	pdd.Enter_Stock__c = cwc.AddQuantity;
	        	pdd.Stock__c = cwc.StockId;
	            pdList.add(pdd);
        	}
        }
        if(pdList.size()>0)
        {
            insert pdList;
            return pdList;
        } 
        return null; 
    }
    @AuraEnabled
    public static List<Stock__c> perDayUseProduct_Apex(String StockListPerDay) {
    	List<Stock_wrapper_class> myList = (List<Stock_wrapper_class>)System.JSON.deserialize(StockListPerDay, List<Stock_wrapper_class>.class);
        list<Stock__c> stList = new list<Stock__c>();
        for(Stock_wrapper_class swc : myList)
        {
            Stock__c st = new Stock__c();
        	st.Id =  swc.Id;
            st.Quantity__c = swc.sQuantity;
            st.Use_Product_Per_Day__c= swc.useProduct;
            st.Name=swc.Name;
            stList.add(st);
        }
        if(stList.size()>0)
        {
            update stList;
            return stList;
        }
        return null; 
    }
    //------------------- (For Payments) - Start  -------------------------------------------------//
    @AuraEnabled
    public static list<Customer__c> PaymentCustomerName_Apex ()
    {
    	List<Customer__c> customer_List = new List <Customer__c>();
		customer_List = [SELECT Id, Name FROM Customer__c ORDER BY Name asc limit 300];
		return customer_List;
    } 
    @AuraEnabled
    public static list<Payment__c> PaymentCustomerDetails_Apex (String customerName)
    {
    	List<Customer__c> customer_List = new List <Customer__c>();
		customer_List = [SELECT Id, Name FROM Customer__c WHERE Name =: customerName limit 300];
		
    	List<Payment__c> payment_List = new List <Payment__c>();
		payment_List = [SELECT Id, Name, Customer__c, Dues_Amount__c, Dues_Date__c, Paid_Amount__c, Pay_Status__c FROM Payment__c WHERE Pay_Status__c = false AND Customer__c IN :customer_List limit 300];
		return payment_List;
    }
    
    @AuraEnabled
    public static String savePaymentDetails (String Cus, String amount, String currDate)
    {
    	String[] str = currDate.split('/');
        string dd = str[0];
        string mm = str[1];
        string yy = str[2];
        Date selectedDate = date.valueOf(yy+'-'+dd+'-'+mm);
        
    	system.debug('------>Cus-'+Cus);
    	system.debug('------>amount-'+amount);
    	system.debug('------>currDate-'+currDate);
    	list<Customer__c> cust = new list<Customer__c>();
    	cust = [select Id, Name from Customer__c where Name =: Cus LIMIT 1];
    	system.debug('cust--------->'+cust);
    	Payment_Details__c pd = new Payment_Details__c();
    	pd.Customer__c = cust[0].Id;
    	pd.Payment_Date__c = selectedDate;
    	pd.Paid_Amount__c = Integer.valueOf(amount);
    	insert pd;
    	if(pd != null)
    	{
    		return 'Success';
    	}
		return null;
    }
    
    @AuraEnabled
	public static List<recentRecordDetails_class> recentRecordDetails_Apex(String selectedDate)
    {
	try{
		List<recentRecordDetails_class> recentRecordDetails_classList = new List<recentRecordDetails_class>();
		
        List<Per_Day_Details__c> specificDetailsList = new List <Per_Day_Details__c>();
        specificDetailsList = [SELECT Id, Name, Quantity__c, Date__c, Customer__c, Amount__c, Cash__c FROM Per_Day_Details__c WHERE Date__c =: Date.valueOf(selectedDate) ];
        system.debug('specificDetailsList----->'+specificDetailsList);
        List<Customer__c> customer_List = new List <Customer__c>();
		customer_List = [SELECT Id, Name FROM Customer__c ORDER By Name LIMIT 300];
        system.debug('customer_List----->'+customer_List);
		for(Customer__c cus : customer_List)
        {
            for(Per_Day_Details__c pd : specificDetailsList)
            {
                if(cus.Id == pd.Customer__c)
                {
                    recentRecordDetails_class wrap_obj = new recentRecordDetails_class();
                    wrap_obj.Id = pd.Id;
                    wrap_obj.Name = cus.Name;
                    wrap_obj.Quantity = pd.Quantity__c;
                    recentRecordDetails_classList.add(wrap_obj);
                }
            }
        }
        return recentRecordDetails_classList;
        system.debug('recentRecordDetails_classList-------->'+recentRecordDetails_classList);
	} catch (Exception ex) {
            String errorString = 'ERROR: ' + ex.getMessage() + ' : ' + ex.getLineNumber();
            System.debug(errorString);
        }
	return null;
    }

    
    @AuraEnabled
    public static list<Per_Day_Details__c> recentRecordDetailsUpdate_Apex (String UpdatePerDay)
    {
        System.debug('---->>>UpdatePerDay>>>>>'+UpdatePerDay);
		List<recentRecordDetails_class> myList = (List<recentRecordDetails_class>)System.JSON.deserialize(UpdatePerDay, List<recentRecordDetails_class>.class);
        list<Per_Day_Details__c> pd_list = new list<Per_Day_Details__c>();
        for(recentRecordDetails_class swc : myList)
        {
            Per_Day_Details__c pd = new Per_Day_Details__c();
        	pd.Id =  swc.Id;
            pd.Quantity__c = swc.Quantity;
            pd_list.add(pd);
        }
        system.debug('pd_list+++++>>>'+pd_list);
        if(pd_list.size()>0)
        {
            update pd_list;
            return pd_list;
        }
        return null;
    }
    @AuraEnabled
	public static list<Customer__c> UpdateRecordCustomerDetails_Apex (list<Customer__c> UpCustomer)
    {
        system.debug('UpCustomer---->>>'+UpCustomer);
        if(UpCustomer.size() > 0)
        {
            update UpCustomer;
            return UpCustomer;
        }
        else
        {
            return null;
        }
    }

	public class recentRecordDetails_class{
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String Quantity {get;set;}
        @AuraEnabled
        public Date SelectedDate {get;set;}
        
        
    }
    //------------------- (For Payments) - Finish  -------------------------------------------------//
	public class customer_wrapper_class{
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String CustomerId {get;set;}
        @AuraEnabled
        public Boolean isDisabled {get;set;}
        @AuraEnabled
        public Boolean isCash {get;set;}
        @AuraEnabled
        public String sQuantity {get;set;}
        @AuraEnabled
        public Boolean isCashDisable {get;set;}
	}
    public class Stock_wrapper_class{
    	@AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String StockId {get;set;}
        @AuraEnabled
        public Integer sQuantity {set;get;}
        @AuraEnabled
        public Decimal useProduct {set;get;}
        @AuraEnabled
        public Decimal AddQuantity {set;get;}
	}
}