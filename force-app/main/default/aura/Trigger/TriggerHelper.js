({
	doInit_helper : function(c, e, h) {
		h.getQuestion_helper(c, e, h);
	},
	getQuestion_helper : function(c, e, h) {
		try {
            c.set('v.isSpinner', true);
            var action = c.get("c.getAllQuestionList_Apex");
            action.setParams({
                isBatch : false,
                isScript : false,
                isTrigger : true
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    console.log('resp__ << ' +JSON.stringify(resp));
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        c.set('v.questionList', resp);
                    } else {
                    	c.set('v.questionList', []);
                    }
                    c.set('v.isSpinner', false);
                }else if (state === 'ERROR'){
                    c.set('v.isSpinner', false);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    c.set('v.questionList', []);
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