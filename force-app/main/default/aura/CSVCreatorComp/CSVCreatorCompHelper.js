({
    createCSVObject : function(cmp, csv) {
        var action = cmp.get('c.getCSVObject');
        action.setParams({
            csv_str : csv
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
	    if(state == "SUCCESS") {
            console.log('Done');
	    //console.log('response.getReturnValue()::::::: ' + JSON.stringify(response.getReturnValue()));
		cmp.set("v.csvObject", response.getReturnValue());
	    }
        });
        $A.enqueueAction(action);
    },
    saveAccountDetails_helper : function (c, e, h, accountList) {
        var action  = c.get("c.insertedAccountListDetails_Apex");
        action.setParams({
            accountList : accountList
        });
        action.setCallback(this,function (response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log('resp:: ' + JSON.stringify(resp));
            }
            else{
                
            }
        });
        $A.enqueueAction(action);  
    },
})