({
	doInit_helper : function(c, e, h) {
		h.getPopulatTutorial_helper(c, e, h);
	},
	getPopulatTutorial_helper : function(c, e, h) {
        try {
            c.set('v.isSpinner', true);
            var action = c.get("c.getPopularTutorialList_Apex");
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp.totalCommunityView) && resp.totalCommunityView != undefined) {
                        c.set('v.totalCommunityView', resp.totalCommunityView);
                    }
                    if(!$A.util.isEmpty(resp.lightningTutorialsList) && resp.lightningTutorialsList != undefined) {
                        c.set('v.lightningTutorialsList', resp.lightningTutorialsList);
                    } else {
                    	c.set('v.lightningTutorialsList', []);
                    }
                    
                    c.set('v.excellentValueCount', resp.totalExcellent);
                    c.set('v.goodValueCount', resp.totalGood);
                    c.set('v.averageValueCount', resp.totalAverage);
                    c.set('v.badValueCount', resp.totalBad);
                    
                    var totalRating = resp.totalRating;
                    var Excellent = (resp.totalExcellent / totalRating) * 100;
                    Excellent = Excellent.toFixed(2);
                    
                    var Good = (resp.totalGood / totalRating) * 100;
                    Good = Good.toFixed(2);
                    
                    var Average = (resp.totalAverage / totalRating) * 100;
                    Average = Average.toFixed(2);
                    
                    var Bad = (resp.totalBad / totalRating) * 100;
                    Bad = Bad.toFixed(2);
                    
                    c.set('v.excellentValue', parseFloat(Excellent));
                    c.set('v.goodValue', parseFloat(Good));
                    c.set('v.averageValue', parseFloat(Average));
                    c.set('v.badValue', parseFloat(Bad));
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
                    c.set('v.lightningTutorialsList', []);
                }else{
                    console.log('Something went wrong, Please check with your admin');
                }
            });
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }
    },
    openRecord_helper : function(c, e, h) {
		var getId = e.target.id;
		if(!$A.util.isEmpty(getId) && getId != undefined) {
			window.open('view?Id='+getId);
		}
	},
    rateUsComplete_helper : function(c, e, h, userName, userEmail, url, rate, description) {
		c.set('v.isAvailableForRating', false);
        try {
            c.set('v.isSpinner', true);
            var action = c.get("c.addRatingFeedback_Apex");
            action.setParams({
                userName : userName,
                email : userEmail,
                url : url,
                rate : rate,
                description : description
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        c.set('v.currentStepRatingValue', '');
                        c.set('v.isAvailableForRating', false);
                        c.set('v.userEmail', '');
                        c.set('v.userName', '');
                        h.getPopulatTutorial_helper(c, e, h);
                        h.showToast(c, e, h, 'success', 'Success!', 'Your Rating is Successfully Submitted.');
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
                    c.set('v.lightningTutorialsList', []);
                }else{
                    console.log('Something went wrong, Please check with your admin');
                }
            });
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }
	},
    showToast : function(c, e, h, type, title, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "title": title,
            "message": msg
        });
        toastEvent.fire();
    }

})