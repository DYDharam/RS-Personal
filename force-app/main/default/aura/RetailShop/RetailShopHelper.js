({
	doInit_Helper : function(c, e, h) {	
	
        
       
        
        
		// Call Recent Per Day Details Start //
		h.recentPerDayDetails_Helper(c, e, h);
		//Call Recent Per Day Details End //
		var d = new Date();
		var month = d.getMonth()+1;
		var day = d.getDate();
		var output = (month<10 ? '0' : '') + month + '/' + 
		(day<10 ? '0' : '') + day + '/' +
		d.getFullYear();
		c.set("v.today", output);
        var actionWrapper = c.get("c.getAllWrapper_APEX");
        actionWrapper.setCallback( this, function(response){
            if (response.getState() === "SUCCESS")
            {
                //console.log('Response Success:');
                if(response.getReturnValue() == null)
                {
                    console.log('Null Value from class On DoInit');
                }
                else
                {
                    c.set("v.customer_wrapper_classAtt", response.getReturnValue());
                }
            }
            else
            {
                console.log('Response Error22222 Do Int:');
            }
        });
       $A.enqueueAction(actionWrapper);
        
        
        
        
        
        var actionWrapper2 = c.get("c.getAllStock_APEX");
        actionWrapper2.setCallback( this, function(response){
            if (response.getState() === "SUCCESS")
            {
                //console.log('Response Success:');
                if(response.getReturnValue() == null)
                {
                    console.log('Null Value from class On DoInit');
                }
                else
                {
                    c.set("v.stock_wrapper_classAtt", response.getReturnValue());
                }
            }
            else
            {
                console.log('Response Error: actionWrapper2');
            }
        });
       $A.enqueueAction(actionWrapper2);
       
       // For Notification Alert --//
       var notification = c.get("c.notification_APEX");
        notification.setCallback( this, function(response){
            if (response.getState() === "SUCCESS")
            {
                //console.log('Response Success:');
                if(response.getReturnValue() == null)
                {
                    console.log('Null Value from class On DoInit');
                }
                else
                {
                    c.set("v.Stock_Notification", response.getReturnValue());
                    var list_size = c.get("v.Stock_Notification");
                    for(var i=0; i<list_size.length; i++)
                    {
	                    if(list_size[0].Name != null)
	                    {
	                    	$('#notification_alert1').show();
	                    	$('#notification_alert2').show();
	                    	$('#details_notification_alert').addClass('slds-table_bordered');
	                    }
	                }
                }
            }
            else
            {
                console.log('Response Error: notification ');
            }
        });
       $A.enqueueAction(notification);
       
       // For Payment //
       var actionWrapper4 = c.get("c.PaymentCustomerName_Apex");
        actionWrapper4.setCallback( this, function(response){
            if (response.getState() === "SUCCESS")
            {
                //console.log('Response Success:');
                if(response.getReturnValue() == null)
                {
                    console.log('Null Value from class On DoInit');
                }
                else
                {
                    c.set("v.PaymentCustomerNameAtt", response.getReturnValue());
                }
            }
            else
            {
                console.log('Response Error: actionWrapper4');
            }
        });
       $A.enqueueAction(actionWrapper4);
       
        
        // For Customer Details::: //
        var newLs = [];
       var actionWrapper5 = c.get("c.AllCustomers");
        actionWrapper5.setCallback( this, function(response){
            if (response.getState() === "SUCCESS")
            {
                //console.log('Response Success:');
                if(response.getReturnValue() == null)
                {
                    console.log('Null Value from class On DoInit');
                }
                else
                {
                    var resp = response.getReturnValue();
                    console.log('----');
                    for(var i=0; i<resp.length; i++)
                    {
                        var obj = resp[i];
                        obj.Mode=true;
                        newLs.push(obj);
                    }
                    c.set("v.allCustomerDetails", newLs);
                    //console.log('NewlIst>>> '+JSON.stringify(newLs));
                }
            }
            else
            {
                console.log('Response Error: actionWrapper5 ');
            }
        });
       $A.enqueueAction(actionWrapper5);
        
        
	},
    NewCustomer_Create_Helper: function(c, e, h){
        $('#New_Customer_Create').show();
    },
    CloseNewCustomer_Helper: function(c, e, h){
        $('#New_Customer_Create').hide();
    },
    CreateCustomerAccount_Helper: function(c, e, h){
    	//var CreateNewCustomerJS = c.get("v.NewCustomer");
        var na = c.find("Name").get("v.value");
        var ad = c.find("Address").get("v.value");
        var ph = c.find("phone").get("v.value");
        var ra = c.find("rate").get("v.value");
        console.log('---->>>na'+na);
        console.log('---->>>ad'+ad);
        console.log('---->>>ph'+ph);
        console.log('---->>>ra'+ra);
    	//console.log('---->'+JSON.stringify(CreateNewCustomerJS));
        if(na == undefined || na == '' || na == ' ')
        {
            c.set("v.Message", 'Please Enter a valid Customer Details');
            $('#backgroundColor').css("background-color", "#cc0000");
            $('#MessageWindow').show();
        }
        else
        {
            var action = c.get("c.newCustomer_apex");
            action.setParams({
                "Name" : na,
                "Address" : ad,
                "Phone" : ph,
                "Rate" : ra
            });
            action.setCallback( this, function(response){
                if (response.getState() === "SUCCESS") {
                    var respon = response.getReturnValue();
                    if(respon==null)
                    {
                        c.set("v.Message", 'Error To Save Customer Details ?');
                        $('#backgroundColor').css("background-color", "#cc0000");
                        $('#MessageWindow').show();
                    }
                    else
                    {
                       h.doInit_Helper(c, e, h);
                       $('#New_Customer_Create').hide();
                       c.set("v.Message", 'New Customer Created');
                       $('#MessageWindow').show();
                    }
                }
                else
                {
                    console.log('Response Error:');
                }
            });
            $A.enqueueAction(action);
        }
        
        
        
    },
    CloseMessageWindow_Helper: function(c, e, h){
        c.set("v.Message", '');
        $('#MessageWindow').hide();
    },
    AddProductQuantity_Helper: function(c, e, h){
    	var quant = c.get("v.stock_wrapper_classAtt");
    	var AddProductStringify = JSON.stringify(quant);
        var inputDate = c.get("v.today");
    	var action = c.get("c.AllStockDetailsToSave_Apex");
    	action.setParams({
            "StockList" : AddProductStringify,
            "DateToday" : inputDate
        });
        action.setCallback( this, function(response){
        console.log('response');
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(respon==null)
            	{
                	c.set("v.Message", 'Error To Save Stock Details ?');
                	$('#backgroundColor').css("background-color", "#cc0000");
        		    $('#MessageWindow').show();
            	}
                else
                {
                   c.set("v.Message", 'Stock Details Saved');
        		   $('#MessageWindow').show();
        		   var actionWrapper2 = c.get("c.getAllStock_APEX");
			        actionWrapper2.setCallback( this, function(response){
			            if (response.getState() === "SUCCESS")
			            {
			                //console.log('Response Success:');
			                if(response.getReturnValue() == null)
			                {
			                    console.log('Null Value from class On DoInit');
			                }
			                else
			                {
			                    c.set("v.stock_wrapper_classAtt", response.getReturnValue());
			                }
			            }
			            else
			            {
			                console.log('Response Error:');
			            }
			        });
			       $A.enqueueAction(actionWrapper2);
			       
			       var notification = c.get("c.notification_APEX");
		        notification.setCallback( this, function(response){
		            if (response.getState() === "SUCCESS")
		            {
		                //console.log('Response Success:');
		                if(response.getReturnValue() == null)
		                {
		                    console.log('Null Value from class On DoInit');
		                }
		                else
		                {
		                    c.set("v.Stock_Notification", response.getReturnValue());
		                    var list_size = c.get("v.Stock_Notification");
		                    for(var i=0; i<list_size.length; i++)
		                    {
			                    if(list_size[0].Name != null)
			                    {
			                    	$('#notification_alert1').show();
			                    	$('#notification_alert2').show();
			                    	$('#details_notification_alert').addClass('slds-table_bordered');
			                    }
			                }
		                }
		            }
		            else
		            {
		                console.log('Response Error:');
		            }
		        });
		       $A.enqueueAction(notification);
                }
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);
    },
    SavePerDayDetailsJS_Helper: function(c, e, h){
        var dataToSaveJS = c.get("v.customer_wrapper_classAtt");
        var per_day_Details = JSON.stringify(dataToSaveJS);
        var inputDate = c.get("v.today");
/*        var convertDate = function (usDate) {
            var dateParts = usDate.split(/(\d{1,2})\/(\d{1,2})\/(\d{4})/);
            return dateParts[3] + "-" + dateParts[1] + "-" + dateParts[2];
        }
        var DoBAfterSetFormat = convertDate(inputDate);
        console.log('date After change Format outDate >>>>>' + DoBAfterSetFormat);
*/        
        var action = c.get("c.savePDD_APEX");
	    action.setParams({
            "addWrapper" : per_day_Details,
            "DateToday" : inputDate
        });
        action.setCallback( this, function(response){
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(response==null)
            	{
                	console.log('Null Value From Class:');
            	}
                else
                {
                	c.set("v.Message", 'Per Day Details Saved');
        		    $('#MessageWindow').show();
        		    
        		    
        		    var actionWrapper = c.get("c.getAllWrapper_APEX");
			        actionWrapper.setCallback( this, function(response){
			            if (response.getState() === "SUCCESS")
			            {
			                //console.log('Response Success:');
			                if(response.getReturnValue() == null)
			                {
			                    console.log('Null Value from class On DoInit');
			                }
			                else
			                {
			                    c.set("v.customer_wrapper_classAtt", response.getReturnValue());
			                }
			            }
			            else
			            {
			                console.log('Response Error:');
			            }
			        });
			       $A.enqueueAction(actionWrapper);
                }
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);
    },
    CashValueDeails_JS_Helper : function(c, e, h){
        var NameId = e.getSource().get("v.name");
        var Value = e.getSource().get("v.value");
        if(Value == true)
        {
            var AllCustomers = c.get("v.customer_wrapper_classAtt");
            for(var i=0; i< AllCustomers.length; i++)
            {
                if(AllCustomers[i].CustomerId == NameId)
                {
                    AllCustomers[i].isDisabled = 'true';
                    AllCustomers[i].sQuantity = '';
                }
            }
        }
        else{
            var AllCustomers = c.get("v.customer_wrapper_classAtt");
            for(var i=0; i< AllCustomers.length; i++)
            {
                if(AllCustomers[i].CustomerId == NameId)
                {
                    AllCustomers[i].isDisabled = 'false';
                }
            }
        }
        c.set("v.customer_wrapper_classAtt", AllCustomers);
    },
    SoldQuantity_JS_Helper : function(c, e, h){
        
		var CustomerIdFromInputField = e.target.getAttribute("data-id");
        var sQuantity_Value = e.target.value;
        var AllCustomersInputField = c.get("v.customer_wrapper_classAtt");
        if(sQuantity_Value !== undefined || sQuantity_Value !== '')
        {
            for(var i=0; i< AllCustomersInputField.length; i++)
            {
                if(AllCustomersInputField[i].CustomerId == CustomerIdFromInputField)
                {
                    //AllCustomersInputField[i].isCashDisable = true;
                    AllCustomersInputField[i].sQuantity = sQuantity_Value;
                }
/*                if(sQuantity_Value.length == 0)
                    AllCustomersInputField[i].isCashDisable = false; */
            }
        }
        c.set("v.customer_wrapper_classAtt", AllCustomersInputField);
        var de = c.get("v.customer_wrapper_classAtt");
        //console.log('-----'+JSON.stringify(de));
    },
    getCurrentDate_Helper : function(c, e, h){
        var datePickerDate = c.get("v.today");
        var wholeDate = datePickerDate.split('-');
        var year = wholeDate[0];
        var month = wholeDate[1];
        var day = wholeDate[2];
        var changedDate = month+'/'+day+'/'+year;
        c.set("v.today", changedDate);
    },
    tabOneAction_Helper: function(c, e, h) {
		var tab1 = c.find('t1');
		var showTab1 = c.find('tab1');

		var tab2 = c.find('t2');
		var showTab2 = c.find('tab2');
        
        var tab3 = c.find('t3');
		var showTab3 = c.find('tab3');
		
		var tab4 = c.find('t4');
		var showTab4 = c.find('tab4');
		
		var tab5 = c.find('t5');
		var showTab5 = c.find('tab5');

		$A.util.addClass(tab1, 'slds-active');
		$A.util.addClass(showTab1, 'slds-show');
		$A.util.removeClass(showTab1, 'slds-hide');


		$A.util.removeClass(tab2, 'slds-active');
		$A.util.removeClass(showTab2, 'slds-show');
		$A.util.addClass(showTab2, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
		$A.util.removeClass(showTab3, 'slds-show');
		$A.util.addClass(showTab3, 'slds-hide');
		
		$A.util.removeClass(tab4, 'slds-active');
		$A.util.removeClass(showTab4, 'slds-show');
		$A.util.addClass(showTab4, 'slds-hide');
		
		$A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(showTab5, 'slds-show'); 
		$A.util.addClass(showTab5, 'slds-hide');
      },
    tabTwoAction_Helper: function(c, e, h) {

		var tab1 = c.find('t1');
		var showTab1 = c.find('tab1');

		var tab2 = c.find('t2');
		var showTab2 = c.find('tab2');
        
        var tab3 = c.find('t3');
		var showTab3 = c.find('tab3');
		
		var tab4 = c.find('t4');
		var showTab4 = c.find('tab4');
		
		var tab5 = c.find('t5');
		var showTab5 = c.find('tab5');

		$A.util.removeClass(tab1, 'slds-active');
		$A.util.removeClass(showTab1, 'slds-show');
		$A.util.addClass(showTab1, 'slds-hide');

        $A.util.addClass(tab2, 'slds-active');
		$A.util.removeClass(showTab2, 'slds-hide');
		$A.util.addClass(showTab2, 'slds-show');
        
        
        $A.util.removeClass(tab3, 'slds-active');
		$A.util.removeClass(showTab3, 'slds-show');
		$A.util.addClass(showTab3, 'slds-hide');
		
		$A.util.removeClass(tab4, 'slds-active');
		$A.util.removeClass(showTab4, 'slds-show');
		$A.util.addClass(showTab4, 'slds-hide');
		
		$A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(showTab5, 'slds-show'); 
		$A.util.addClass(showTab5, 'slds-hide');
	}, 
    
    tabThreeAction_Helper : function(c, e, h){
        var tab1 = c.find('t1');
		var showTab1 = c.find('tab1');

		var tab2 = c.find('t2');
		var showTab2 = c.find('tab2');

        var tab3 = c.find('t3');
		var showTab3 = c.find('tab3');
		
		var tab4 = c.find('t4');
		var showTab4 = c.find('tab4');
		
		var tab5 = c.find('t5');
		var showTab5 = c.find('tab5');
        
		$A.util.removeClass(tab1, 'slds-active');
		$A.util.removeClass(showTab1, 'slds-show');
		$A.util.addClass(showTab1, 'slds-hide');
        

        $A.util.removeClass(tab2, 'slds-active');
		$A.util.removeClass(showTab2, 'slds-show');
		$A.util.addClass(showTab2, 'slds-hide');  
        
        
        $A.util.addClass(tab3, 'slds-active');
        $A.util.addClass(showTab3, 'slds-hide'); 
		$A.util.addClass(showTab3, 'slds-show');
		
		$A.util.removeClass(tab4, 'slds-active');
		$A.util.removeClass(showTab4, 'slds-show');
		$A.util.addClass(showTab4, 'slds-hide');
		
		$A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(showTab5, 'slds-show'); 
		$A.util.addClass(showTab5, 'slds-hide');
        
    },
    tabFourAction_Helper : function(c, e, h){
        var tab1 = c.find('t1');
		var showTab1 = c.find('tab1');

		var tab2 = c.find('t2');
		var showTab2 = c.find('tab2');

        var tab3 = c.find('t3');
		var showTab3 = c.find('tab3');
		
		var tab4 = c.find('t4');
		var showTab4 = c.find('tab4');
		
		var tab5 = c.find('t5');
		var showTab5 = c.find('tab5');
        
		$A.util.removeClass(tab1, 'slds-active');
		$A.util.removeClass(showTab1, 'slds-show');
		$A.util.addClass(showTab1, 'slds-hide');
        

        $A.util.removeClass(tab2, 'slds-active');
		$A.util.removeClass(showTab2, 'slds-show');
		$A.util.addClass(showTab2, 'slds-hide');  
        
        
        $A.util.removeClass(tab3, 'slds-active');
		$A.util.removeClass(showTab3, 'slds-show');
		$A.util.addClass(showTab3, 'slds-hide');
		
		$A.util.addClass(tab4, 'slds-active');
        $A.util.addClass(showTab4, 'slds-hide'); 
		$A.util.addClass(showTab4, 'slds-show');
		
		$A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(showTab5, 'slds-show'); 
		$A.util.addClass(showTab5, 'slds-hide');
        
    },
    
    tabFiveAction_Helper : function(c, e, h){
        var tab1 = c.find('t1');
		var showTab1 = c.find('tab1');

		var tab2 = c.find('t2');
		var showTab2 = c.find('tab2');

        var tab3 = c.find('t3');
		var showTab3 = c.find('tab3');
		
		var tab4 = c.find('t4');
		var showTab4 = c.find('tab4');
		
		var tab5 = c.find('t5');
		var showTab5 = c.find('tab5');
        
		$A.util.removeClass(tab1, 'slds-active');
		$A.util.removeClass(showTab1, 'slds-show');
		$A.util.addClass(showTab1, 'slds-hide');
        

        $A.util.removeClass(tab2, 'slds-active');
		$A.util.removeClass(showTab2, 'slds-show');
		$A.util.addClass(showTab2, 'slds-hide');  
        
        
        $A.util.removeClass(tab3, 'slds-active');
		$A.util.removeClass(showTab3, 'slds-show');
		$A.util.addClass(showTab3, 'slds-hide');
		
		$A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(showTab4, 'slds-show'); 
		$A.util.addClass(showTab4, 'slds-hide');
		
		$A.util.addClass(tab5, 'slds-active');
        $A.util.addClass(showTab5, 'slds-hide'); 
		$A.util.addClass(showTab5, 'slds-show');
        
    },
    
    getFromDate_Helper : function(c, e, h){
        var datePickerDate = c.get("v.from");
        var wholeDate = datePickerDate.split('-');
        var year = wholeDate[0];
        var month = wholeDate[1];
        var day = wholeDate[2];
        var changedDate = month+'/'+day+'/'+year;
        c.set("v.from", changedDate);
        
        var toDateCheck1 = c.get("v.from");
        var toDateCheck2 = c.get("v.to");
        var Name = c.get("v.customerName");
        if(toDateCheck1 != null && toDateCheck2 != null && Name != null)
        {
        	h.getDetailsFromAndToDate (c, e, h, toDateCheck1, toDateCheck2, Name);
        }
    },
    customer_name_Helper : function(c, e, h){
    var Name = e.getSource().get("v.value");
    c.set("v.customerName", Name);
    c.set("v.from", '');
    c.set("v.to", '');
    },
    getToDate_Helper : function(c, e, h){
        var datePickerDate = c.get("v.to");
        var wholeDate = datePickerDate.split('-');
        var year = wholeDate[0];
        var month = wholeDate[1];
        var day = wholeDate[2];
        var changedDate = month+'/'+day+'/'+year;
        c.set("v.to", changedDate);
        
        var toDateCheck1 = c.get("v.from");
        var toDateCheck2 = c.get("v.to");
        var Name = c.get("v.customerName");
        if(toDateCheck1 != null && toDateCheck2 != null && Name != null)
        {
        	h.getDetailsFromAndToDate (c, e, h, toDateCheck1, toDateCheck2, Name);
        }
    },
    getDetailsFromAndToDate : function(c, e, h, toDateCheck1, toDateCheck2, Name){
    	var dt = toDateCheck1.split('/');
    	var dt1 = dt[2]+'-'+dt[0]+'-'+dt[1];
    	
    	var dtt = toDateCheck2.split('/');
    	var dt2 = dtt[2]+'-'+dtt[0]+'-'+dtt[1];
    	
    	var action = c.get("c.showAllDataOfPerDayDetails_APEX");
	    action.setParams({
            "date1" : dt1,
            "date2" : dt2,
            "name" : Name
        });
        action.setCallback( this, function(response){
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(response==null)
            	{
                	console.log('Null Value From Class:');
            	}
                else
                {
                   c.set("v.details_From_And_To", response.getReturnValue());
                   var detailsAll = c.get("v.details_From_And_To");
                   var totalQuantity=0;
                   var totalAmount=0;
                   for(var i=0; i<detailsAll.length; i++)
                   {
                	   totalQuantity = totalQuantity + parseFloat(detailsAll[i].Quantity__c);
                	   totalAmount = totalAmount + detailsAll[i].Amount__c;
                   }
                   console.log('TTL QUAN'+totalQuantity);
                   console.log('TTL Amount'+totalAmount);
                   c.find("total_Quantity").set("v.value",totalQuantity); 
                   c.find("total_amount").set("v.value",totalAmount);
                }
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);
    },
    changePerDayProductDetailsJS_Helper: function(c, e, h){
        var stockList = c.get("v.stock_wrapper_classAtt");
        var newProductList = [];
        var sss = JSON.stringify(stockList);
        var action = c.get("c.perDayUseProduct_Apex");
	    action.setParams({
            "StockListPerDay" : sss
        });
        action.setCallback( this, function(response){
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(response==null)
            	{
                	c.set("v.Message", 'Error To Save Per Day Use Product ?');
                	$('#backgroundColor').css("background-color", "#cc0000");
        		    $('#MessageWindow').show();
            	}
                else
                {
                    c.set("v.Message", 'Saved Per Day Use Product !');
        		    $('#MessageWindow').show();
                }
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);
    },
    getPaymentDetailsACNameJS_Helper : function(c, e, h){
    	//var getName = c.get("v.PaymentCustomerNameAtt");
    	
    	
    	var Name = e.getSource().get("v.value");
    	c.find("getPaymentName").set("v.value",Name);
    	if(Name !== undefined)
    	{
    		console.log('name'+Name);
    		/*var action = c.get("c.PaymentCustomerName_Apex");
    		action.setParams({
	            "customerName" : Name
	        });
    		action.setCallback(this, function(response)){
    			if(response.getState() === "SUCCESS"){
    				var respon = response.getReturnValue();
    				if(response == null)
    				{
    					console.log('Null Value From The Class');
    				}
    				else
    				{
    					//c.set("v.PaymentDetailsACName", response.getReturnValue());
    				}
    			}
    			else
    			{
    				console.log('Response Error:');
    			}
    		}
    		$A.enqueueAction(action);*/
    		
    		var action = c.get("c.PaymentCustomerDetails_Apex");
		    action.setParams({
	            "customerName" : Name
	        });
	        action.setCallback( this, function(response){
	            if (response.getState() === "SUCCESS") {
	            	var respon = response.getReturnValue();
	            	if(respon==null)
	            	{
	                	
	            	}
	                else
	                {
	                  c.set("v.PaymentDetailsACName", response.getReturnValue());
	                  var detailsAll = c.get("v.PaymentDetailsACName");
	                   var totalQuantity=0;
	                   var totalAmount=0;
	                   for(var i=0; i<detailsAll.length; i++)
	                   {
	                	   //totalQuantity = totalQuantity + parseFloat(detailsAll[i].Quantity__c);
	                	   totalAmount = totalAmount + detailsAll[i].Dues_Amount__c;
	                   }
	                   //console.log('TTL QUAN'+totalQuantity);
	                   console.log('TTL Amount'+totalAmount);
	                   //c.find("total_Quantity").set("v.value",totalQuantity); 
	                   c.find("TotalDuesAmount").set("v.value",totalAmount);
	                }
	            }
	            else
	            {
	            	console.log('Response Error:');
	            }
	        });
		    $A.enqueueAction(action);
    	}
    },
    recentPerDayDetails_Helper: function(c, e, h){
        /*var action = c.get("c.recentPerDayDetails_Apex");
        action.setCallback( this, function(response){
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(response==null)
            	{
                	console.log('Null from class');
            	}
                else
                {
                    c.set("v.RecentPerDayDetails", response.getReturnValue());
        		    console.log('--Done--Complete---');
                }
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);*/
	    
	    var actionWrapper = c.get("c.recentPerDayDetails_Apex");
        actionWrapper.setCallback( this, function(response){
            if (response.getState() === "SUCCESS")
            {
                //console.log('Response Success:');
                if(response.getReturnValue() == null)
                {
                    console.log('Null Value from class On DoInit');
                }
                else
                {
                    c.set("v.RecentPerDayDetails", response.getReturnValue());
                }
            }
            else
            {
                console.log('Response Error: actionWrapper');
            }
        });
       $A.enqueueAction(actionWrapper);
    },
    payAmountJS_Helper : function(c, e, h){
    	//-----//
    	var name = c.find("getPaymentName").get("v.value");
    	console.log('Name------->'+name);
    	var amt = c.find("paidAmountFromCustomer").get("v.value");
    	console.log('Amount------->'+amt);
    	var curDate = c.get("v.today");
    	if(name == undefined || name == '')
    	{
    		c.set("v.Message", 'Please Select Any Name First !');
            $('#backgroundColor').css("background-color", "#cc0000");
            $('#MessageWindow').show();
    	}
    	else if(amt == undefined || amt == '')
    	{
    		c.set("v.Message", 'Please Enter Your Amount !');
            $('#backgroundColor').css("background-color", "#cc0000");
            $('#MessageWindow').show();
    	}
    	else
    	{
    	var action = c.get("c.savePaymentDetails");
	    action.setParams({
            "Cus" : name,
            "amount" : amt,
            "currDate" : curDate
        });
        action.setCallback( this, function(response){
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(respon==null)
            	{
                	c.set("v.Message", 'Error To Save Payment ?');
                	$('#backgroundColor').css("background-color", "#cc0000");
        		    $('#MessageWindow').show();
        		    $('#paidAmountFromCustomer').value="";
            	}
                else
                {
                   c.set("v.Message", 'Payment Successfully Saved');
        		   $('#MessageWindow').show();
        		   $('#paidAmountFromCustomer').value='';
        		   c.find("paidAmountFromCustomer").set("v.value", "");
        		}
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);
    	}
    	
    },
    letMeOutJS_Helper : function(c, e, h){
        $.session.clear();
    	var LogoutEventHelper = c.getEvent("LogoutEvent");
        LogoutEventHelper.fire();
    },
    showfile_Helper : function(c, e, h){
        console.log('-------->Helper');
        var fileInput = c.find("file").getElement();
        console.log('fileInput--->'+fileInput);
        var file = fileInput.files[0];
        console.log('file--->'+file);
        if (file === null || file === undefined) {
            console.error('No File was selected');
        } else {
            c.set("v.FileName", file.name);
            c.set("v.File", file);
            console.log('Set the attribute');
        }
    },
    getRecentDetails_Helper : function (c, e, h){
        console.log('Innn');
        var getDate = e.currentTarget.name;
        
        var action = c.get("c.recentRecordDetails_Apex");
	    action.setParams({
            "selectedDate" : getDate
        });
        action.setCallback( this, function(response){
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(respon==null)
            	{
                	c.set("v.Message", 'Error To Save Payment ?');
                	$('#backgroundColor').css("background-color", "#cc0000");
        		    $('#MessageWindow').show();
        		    $('#paidAmountFromCustomer').value="";
            	}
                else
                {
                   c.set("v.CurrentCustomerDetails", respon);
                   $('#popupContainer').show();
        		}
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);
        
        
    },
    close_Helper : function (c, e, h){
        $('#popupContainer').hide();
    },
    recentPerDayDetailUpdateJS_Helper : function (c, e, h){
        var perDayLIst = c.get("v.CurrentCustomerDetails");
        var perDayStr = JSON.stringify(perDayLIst);
        
        var action = c.get("c.recentRecordDetailsUpdate_Apex");
  		action.setParams({
            "UpdatePerDay" : perDayStr
        });
        action.setCallback( this, function(response){
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(respon==null)
            	{
                	c.set("v.Message", 'Error To Save Update Per Day Details ?');
                	$('#backgroundColor').css("background-color", "#cc0000");
        		    $('#MessageWindow').show();
            	}
                else
                {
                   console.log('Success');
                   c.set("v.Message", 'Successfully Saved Per Day Details.');
        		   $('#MessageWindow').show();
        		}
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action); 
    },
    UpdateSoldQuantity_JS_Helper : function(c, e, h)
    {
    	var FromInputField = e.target.getAttribute("data-id");
        var Quantity_Value = e.target.value;
        var AllUpdateInputField = c.get("v.CurrentCustomerDetails");
        for(var i=0; i< AllUpdateInputField.length; i++)
        {
            if(AllUpdateInputField[i].Id == FromInputField)
            {
                AllUpdateInputField[i].Quantity = Quantity_Value;
            }
        }
        c.set("v.CurrentCustomerDetails", AllUpdateInputField);
        var de = c.get("v.CurrentCustomerDetails");
        //console.log('----->_.>_____>>>>'+JSON.stringify(de));
    },
    OpenEditModeCustomerJS_Helper : function(c, e, h){
        var GetIdToEdit = e.target.getAttribute("data-id");
        var totalCustomerList = c.get("v.allCustomerDetails");
        for(var i=0; i<totalCustomerList.length; i++)
        {
            if(totalCustomerList[i].Id == GetIdToEdit)
            {
                totalCustomerList[i].Mode = false;
            }
        }
        c.set("v.allCustomerDetails",totalCustomerList);
    },
    updateCustomerDetailsJS_Helper : function(c, e, h){
        var GetIdToEdit = e.target.getAttribute("data-id");
        //console.log('--->getId'+GetIdToEdit);
        var value1 = e.target.id;//e.target.value;
        var valueData = e.target.value;
        var cheData = e.target.checked;
        //console.log('che-0-----'+cheData);
        //console.log('value1'+value1);
        //console.log('valueData--->>'+valueData);
        var totalCustomerList = c.get("v.allCustomerDetails");
        for(var i=0; i<totalCustomerList.length; i++)
        {
            if(totalCustomerList[i].Id == GetIdToEdit)
            {
                if(value1 === 'Name')
                {
                    totalCustomerList[i].Name = valueData;
                }
                else if(value1 === 'Address')
                {
                    totalCustomerList[i].Address__c = valueData;
                }
                else if(value1 === 'Phone')
                {
                    totalCustomerList[i].Phone__c = valueData;
                }
                else if(value1 === 'Rate')
                {
                    totalCustomerList[i].Rate__c = valueData;
                }
                else if(value1 === 'status')
                {
                    totalCustomerList[i].status__c = cheData;
                }
            }
        }
        c.set("v.allCustomerDetails",totalCustomerList);
        //console.log('0----->>>'+JSON.stringify(c.get("v.allCustomerDetails")));
    },
    OpenViewModeCustomerJS_Helper : function(c, e, h){
        var GetIdToEdit = e.target.getAttribute("data-id");
        //console.log('GetIdToEdit----'+GetIdToEdit);
        var newListToUpdate = [];
        var totalCustomerList = c.get("v.allCustomerDetails");
        for(var i=0; i<totalCustomerList.length; i++)
        {
            if(totalCustomerList[i].Id== GetIdToEdit)
            {
                newListToUpdate.push(totalCustomerList[i]);
            }
        }
        //console.log('---_>>>newListToUpdate>>'+JSON.stringify(newListToUpdate));
        var action = c.get("c.UpdateRecordCustomerDetails_Apex");
  		action.setParams({
            "UpCustomer" : newListToUpdate
        });
        action.setCallback( this, function(response){
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(respon==null)
            	{
                    console.log('NULLLLLLLLLL');
                	c.set("v.Message", 'Error To Update Customer Record ?');
                	$('#backgroundColor').css("background-color", "#cc0000");
        		    $('#MessageWindow').show();
            	}
                else
                {
                   console.log('Success');
                   //c.set("v.Message", 'Successfully Updated Customer Details.');
        		   //$('#MessageWindow').show();
                    for(var i=0; i<totalCustomerList.length; i++)
                    {
                        if(totalCustomerList[i].Id === GetIdToEdit)
                        {
                            totalCustomerList[i].Mode = true;
                        }
                    }
                    //console.log('totalCustomerList---'+JSON.stringify(totalCustomerList));
                    c.set("v.allCustomerDetails",totalCustomerList);
                    //console.log('======'+JSON.stringify(c.get("v.allCustomerDetails")));
        		}
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action); 
    },
})