({
    onInit_helper : function(c, e, h) {
        try {
            var action = c.get("c.getSobjectRecord_Apex");
            action.setParams({
                strObjectName : c.get('V.objectAPIName'),
                selectedRecord : c.get('v.value')
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state-222->>> '+state);
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        var getSelectRecord = c.get("v.oRecord");
                        var compEvent = c.getEvent("oSelectedRecordEvent");
                        compEvent.setParams({"recordByEvent" : resp });  
                        compEvent.fire();
                    }
                }else if (state === 'ERROR'){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }else{
                    console.log('Something went wrong, Please check with your admin');
                }
            });
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }
    },
    searchHelper : function(component,event,getInputkeyWord) {
        try {
            // call the apex class method 
            var action = component.get("c.fetchLookUpValues");
            // set param to method  
            action.setParams({
                searchKeyWord : getInputkeyWord,
                ObjectName : component.get("v.objectAPIName")
            });
            // set a callBack    
            action.setCallback(this, function(response) {
                $A.util.removeClass(component.find("mySpinner"), "slds-show");
                var state = response.getState();
                console.log('state-->>> '+state);
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                    if (storeResponse.length == 0) {
                        component.set("v.Message", 'No Result Found...');
                    } else {
                        component.set("v.Message", '');
                    }
                    // set searchResult list with return value from server.
                    console.log('storeResponse--'+JSON.stringify(storeResponse));
                    component.set("v.listOfSearchRecords", storeResponse);
                }
                
            });
            // enqueue the Action  
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }
        
    },
    
})