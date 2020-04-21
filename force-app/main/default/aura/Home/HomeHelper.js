({
    updateSocialRecord_helper : function(c, e, h, userId, socialType) {
        try {
            var action = c.get("c.updateSocialCount_Apex");
            action.setParams({
                userId : userId,
                socialType : socialType
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        console.log('resp-->>'+resp);
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
    sendEmailToSalesforceUser_helper : function(c, e, h, getUserEmail) {
        var emailComponent = c.find('emailComponent');
        $A.util.removeClass(emailComponent, 'slds-hide');
        $A.util.addClass(emailComponent, 'slds-show');
        c.set('v.senderEmail', getUserEmail);
    },
    closeModalSendMail_helper : function(c, e, h) {
        var emailComponent = c.find('emailComponent');
        $A.util.addClass(emailComponent, 'slds-hide');
        $A.util.removeClass(emailComponent, 'slds-show');
        c.set('v.senderEmail', '');
        c.set('v.senderSubject', '');
        c.set('v.senderBody', '');
        c.set('v.currentUserName', '');
    },
    sendHelper_helper: function(c, getEmail, getSubject, getbody) {   
        var action = c.get("c.sendMailMethod"); 
        action.setParams({
            'mMail': getEmail,
            'mSubject': getSubject,
            'mbody': getbody
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var storeResponse = response.getReturnValue();
                console.log('Email Sent to the user.');
                
                var toastEvent = $A.get("event.force:showToast");
                toastEvent.setParams({
                    title:'Email Sent',
                    message: 'Email Sent to the Salesforce User.',
                    duration: 4000,
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                
            }
        });
        $A.enqueueAction(action);
    },
    addQuestionModal_helper : function (c, e, h) {
        $A.createComponent(
            "c:Modal",
            {
                "title": 'Modal Name Here',
                "addQuestionSection": true
            },
            function(msgBox){
                if (c.isValid()) {
                    var targetCmp = c.find('ModalDialogPlaceholder');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body);
                }
            }
        );
    },
    saveQuestionDetailsJS_helper : function (c, e, h, questionName, optionAnswerList) {
        try {
            var action = c.get("c.saveQuestionDetails_Apex");
            action.setParams({
                questionName : questionName,
                optionAnswerList : JSON.stringify(optionAnswerList)
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        var cmpRefreshLightningMenuEvent = c.getEvent("cmpRefreshLightningMenuEvent");
                        cmpRefreshLightningMenuEvent.fire();
                    }
                    c.destroy();
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
                    c.destroy();
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