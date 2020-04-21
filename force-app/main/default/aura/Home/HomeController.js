({
	updateSocialRecord : function(c, e, h) {
        var getValue = e.target.name;
        var getValueList = getValue.split(',');
        var userId = getValueList[0];
        var socialType = getValueList[1];
        var socialLinkUrl = getValueList[2];
        if(!$A.util.isEmpty(userId) && userId != undefined && !$A.util.isEmpty(socialType) && socialType != undefined) {
            h.updateSocialRecord_helper(c, e, h, userId, socialType);
        }
        if(!$A.util.isEmpty(socialLinkUrl) && socialLinkUrl != undefined) {
            window.open(socialLinkUrl);
        }
	},
    sendEmailToSalesforceUser : function(c, e, h) {
        var getUserDetails = e.target.id;
        var getUserEmail = '';
        var getUserName = '';
        var newListDetails = [];
        if(getUserDetails.includes(',')) {
            newListDetails = getUserDetails.split(',');
            getUserEmail = newListDetails[0];
            getUserName = newListDetails[1];
        }
        if(!$A.util.isEmpty(getUserEmail) && getUserEmail != undefined) {
            h.sendEmailToSalesforceUser_helper(c, e, h, getUserEmail);
        }
        if(!$A.util.isEmpty(getUserName) && getUserName != undefined) {
            c.set('v.currentUserName', getUserName);
        }
	},
    sendMail: function(c, e, h) {
        var getEmail = c.get("v.senderEmail");
        var getSubject = c.get("v.senderSubject");
        var getbody = c.get("v.senderBody"); 
        if ($A.util.isEmpty(getSubject) && getSubject != undefined) {
            alert('Please Enter any Subject');
        } else if ($A.util.isEmpty(getEmail) || !getEmail.includes("@")) {
            alert('Please Enter valid Email Address');
        } else {
            h.sendHelper_helper(c, getEmail, getSubject, getbody);
        }
    },
    closeModalSendMail: function(c, e, h) {
        h.closeModalSendMail_helper(c, e, h);
    },
    addQuestionModal: function(c, e, h) {
        h.addQuestionModal_helper(c, e, h);
    },
    saveQuestionDetailsJS: function(c, e, h) {
        var questionName = e.getParam("questionName");
        var optionAnswerList = e.getParam("optionAnswerList");
        console.log('Received Here');
        console.log('questionName-->> '+questionName);
        console.log('optionAnswerList-->> '+JSON.stringify(optionAnswerList));
        if(!$A.util.isEmpty(questionName) && questionName != undefined) {
            console.log('BOTH IN');
            h.saveQuestionDetailsJS_helper(c, e, h, questionName, optionAnswerList);
        }
    },
})