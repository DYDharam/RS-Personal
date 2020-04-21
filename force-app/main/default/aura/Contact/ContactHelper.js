({
    getUserDetails_helper : function(c, e, h) {
        try {
            var action = c.get("c.getProfileUser_Apex");
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined && !$A.util.isEmpty(resp.Id)) {
                        c.set('v.currentUserProfileDetails', resp);
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
	saveContactUs_helper : function(c, e, h, contactUsRecord) {
        try {
            var action = c.get("c.createContactUsRecord");
            action.setParams({
                contactUsRecord : contactUsRecord
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined && !$A.util.isEmpty(resp.Id)) {
                        var msg = 'Your record ' + resp.Name + ' ' + resp.Last_Name__c + ' is created';
                        h.toastMessage_helper(c, e, h, 'Success', msg, 'Tempaleses', '3000', 'info_alt', 'success', 'pester');
                        c.set('v.contactUsInfo', {});
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
    toastMessage_helper : function(c, e, h, title, message, messageTemplate, duration, key, type, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            messageTemplate: messageTemplate,
            duration: duration,
            key: key,
            type: type,
            mode: mode
        });
        toastEvent.fire();
    },
    checkEmailAddress : function(c, e, h, verifyEmail) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(verifyEmail)) {
            return true;
        } else {
            return false;
        }
    },
})