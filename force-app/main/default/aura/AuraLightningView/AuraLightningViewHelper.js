({
	doInit_helper : function(c, e, h, recordId) {
		h.getSobjectDetails_helper(c, e, h, recordId);
	},
    getSobjectDetails_helper : function(c, e, h, recordId) {
        try {
            var action = c.get("c.getAllTutorialList_Apex");
            action.setParams({
                lightningTutorialId : recordId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        c.set('v.sObjectDetails', resp[0]);
                    } else {
                        c.set('v.sObjectDetails', {});
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
                    c.set('v.sObjectDetails', {});
                }else{
                    console.log('Something went wrong, Please check with your admin');
                }
            });
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }
    },
})