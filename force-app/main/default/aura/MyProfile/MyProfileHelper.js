({
	init_helper : function (c, e, h) {
        h.getUserDetails_helper(c, e, h);
    },
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
    upHoverFunction_helper : function (c, e, h, getSection) {
        if(getSection == 'logo') {
            c.set('v.isLogo', true);
        } else if(getSection == 'resume') {
            c.set('v.isResume', true);
        } else if(getSection == 'about') {
            c.set('v.isAbout', true);
        } else if(getSection == 'contact') {
            c.set('v.isContact', true);
        }
    },
    downHoverFunction_helper : function (c, e, h, getSection) {
        if(getSection == 'logo') {
            c.set('v.isLogo', false);
        } else if(getSection == 'resume') {
            c.set('v.isResume', false);
        } else if(getSection == 'about') {
            c.set('v.isAbout', false);
        } else if(getSection == 'contact') {
            c.set('v.isContact', false);
        }
    },
})