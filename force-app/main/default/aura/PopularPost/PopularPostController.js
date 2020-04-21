({
	doInit : function(c, e, h) {
		h.doInit_helper(c, e, h);
	},
	openRecord : function(c, e, h) {
		h.openRecord_helper(c, e, h);
	},
    openPage : function(c, e, h) {
        var getId = e.target.id;
		if(!$A.util.isEmpty(getId) && getId != undefined) {
			window.open('view?name='+getId);
		}
    },
    handleLikeButtonClick : function (c, e, h) {
        var buttonLikeState = c.get('v.handleLikeButtonClick');
        c.set('v.buttonLikeState', !buttonLikeState);
    },
    currentStepRating : function(c, e, h) {
        var getStatus = e.getSource().get('v.label');
        c.set('v.currentStepRatingValue', getStatus);
        c.set('v.isAvailableForRating', true);
    },
    rateUsComplete : function(c, e, h) {
        var userName = c.get('v.userName');
        userName=userName.trim();
        var userEmail = c.get('v.userEmail');
        userEmail=userEmail.trim();
        var description = c.get('v.description');
        var rate = c.get('v.currentStepRatingValue');
        var url = window.location.href;
        if(!$A.util.isEmpty(userName) && userName != undefined) {
            if(!$A.util.isEmpty(userEmail) && userEmail != undefined) {
                if(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(userEmail)) {
                    h.rateUsComplete_helper(c, e, h, userName, userEmail, url, rate, description);
                } else {
                    h.showToast(c, e, h, 'error', 'Error!', 'Please Verify Your Email');
                }
            } else {
                h.showToast(c, e, h, 'error', 'Error!', 'Please Enter Your Email');
            }
        } else {
            h.showToast(c, e, h, 'error', 'Error!', 'Please Enter Your Name');
        }
    },
})