({
    doInit_helper : function(c, e, h) {
        try {
            var action = c.get("c.generateCSV_Apex");
            /*action.setParams({
                strObjectName : 'Contact'
            });*/
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
					var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        console.log('resp--.>>> ' + JSON.stringify(resp));
                        const blob = new Blob(resp, {type: contentType});
                        const blobUrl = URL.createObjectURL(blob);
                        
                        window.location = blobUrl;
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
    getComplteWrapper_helper : function(c, e, h) {
        //h.showSpinne_Helper(c, e, h);
        try {
            var action = c.get("c.getLightningTutorials_Apex");
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        console.log('resp.userListInfo--<<>>>> '+JSON.stringify(resp.userListInfo));
                        /*var questionsList = resp.questionsList;
                        if(!$A.util.isEmpty(questionsList) && questionsList != undefined) {
                            c.set('v.questionsList', questionsList);
                        } else {
                            c.set('v.questionsList', []);
                        }
                        if(!$A.util.isEmpty(resp.userInfo) && resp.userInfo != undefined) {
                            c.set("v.userInfo", resp.userInfo);
                        } else {
                            c.set("v.userInfo", {});
                        }
                        if(!$A.util.isEmpty(resp.lightningVideoList) && resp.lightningVideoList != undefined) {
                            c.set('v.lightningVideosList', resp.lightningVideoList);
                        } else {
                            c.set('v.lightningVideosList', []);
                        }*/
                        if(!$A.util.isEmpty(resp.userListInfo) && resp.userListInfo != undefined) {
                            c.set('v.userList', resp.userListInfo);
                        } else {
                            c.set('v.userList', []);
                        }
                        /*if(!$A.util.isEmpty(resp.lightningTutorialList) && resp.lightningTutorialList != undefined) {
                            c.set('v.lightningTutorialsList', resp.lightningTutorialList);
                        } else {
                            c.set('v.lightningTutorialsList', []);
                        }
                        if(!$A.util.isEmpty(resp.questionAnsersList) && resp.questionAnsersList != undefined) {
                            c.set('v.questionAnsersList', resp.questionAnsersList);
                        } else {
                            c.set('v.questionAnsersList', []);
                        }
                        if(!$A.util.isEmpty(resp.contactInfo) && resp.contactInfo != undefined) {
                            var contactObj = resp.contactInfo;
                            if($A.util.isEmpty(contactObj.Facebook__c)) {
                                contactObj.Facebook__c = 0;
                            }
                            if($A.util.isEmpty(contactObj.Google_Plus__c)) {
                                contactObj.Google_Plus__c = 0;
                            }
                            if($A.util.isEmpty(contactObj.Twitter__c)) {
                                contactObj.Twitter__c = 0;
                            }
                            if($A.util.isEmpty(contactObj.Linkedin__c)) {
                                contactObj.Linkedin__c = 0;
                            }
                            if($A.util.isEmpty(contactObj.Blogger__c)) {
                                contactObj.Blogger__c = 0;
                            }
                            c.set('v.contactInfo', contactObj);
                        } else {
                            c.set('v.contactInfo', []);
                        }*/
                        //h.hideSpinne_Helper(c, e, h);
                    }
                    //h.hideSpinne_Helper(c, e, h);
                }else if (state === 'ERROR'){
                    //h.hideSpinne_Helper(c, e, h);
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
                    //h.hideSpinne_Helper(c, e, h);
                    console.log('Something went wrong, Please check with your admin');
                }
            });
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }
    },
})