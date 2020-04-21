({
	doInit_helper : function(c, e, h, recordId) {
        var action = c.get("c.CloneWithChildrenCtrlComponent_Apex"); 
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                //for(var i = 0; i < storeResponse.length; i++) {
                    console.log('storeResponse-->>>>'+JSON.stringify(storeResponse));
                //}
                
                //console.log('storeResponse-->> '+JSON.stringify(storeResponse));
                //var ChildObjectWrapper = storeResponse.ChildObjectWrapper;
                //console.log('ChildObjectWrapper->>'+JSON.stringify(ChildObjectWrapper));
            }
        });
        $A.enqueueAction(action);
	},
})