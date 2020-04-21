({
	doInit_helper : function(c, e, h) {
		h.getObjectNameWithIcons_helper(c, e, h);
	},
	getObjectNameWithIcons_helper : function(c, e, h) {
        try {
            var action = c.get("c.getObjectNameWithIcons");
            action.setParams({
                isStandard : false,
                isCustom : true
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    console.log('resp-->>> ' + JSON.stringify(resp));
                    c.set('v.cusWrapperOfObjectNIconsList', resp);
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
})