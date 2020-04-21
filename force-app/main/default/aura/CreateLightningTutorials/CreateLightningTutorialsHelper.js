({
    createRecord_helper: function (c, e, h, sObjectName) {
        if(!$A.util.isEmpty(sObjectName) && sObjectName == 'Lightning_Videos__c') {
            c.set('v.openModal', true);
            c.set('v.newRecordMode', true);
        }
        if(!$A.util.isEmpty(sObjectName) && sObjectName == 'Lightning_Tutorials__c') {
            c.set('v.openModal', true);
            c.set('v.newLightningTutorials', true);
        }
    },
    createLightningRecord_helper: function (c, e, h, sObjectName) {
        if(sObjectName == 'Lightning_Videos__c') {
            var newLightningRecordCreate = c.get('v.newLightningRecordCreate');
        } else if(sObjectName == 'Lightning_Tutorials__c') {
            var newLightningRecordCreate = c.get('v.newLightningTutorialsCreate');
        }
        if(!$A.util.isEmpty(newLightningRecordCreate.Name)) {
            try {
                if(sObjectName == 'Lightning_Videos__c') {
                    var action = c.get("c.saveLightningRecord_Apex");
                } else if(sObjectName == 'Lightning_Tutorials__c') {
                    var action = c.get("c.saveLightningTutorialRecord_Apex");
                }
                action.setParams({
                    createLightningRecord : newLightningRecordCreate
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === 'SUCCESS'){
                        var resp = response.getReturnValue();
                        if(!$A.util.isEmpty(resp) && resp != undefined) {
                            if(resp == 'success') {
                                var cmpRefreshLightningMenuEvent = c.getEvent("cmpRefreshLightningMenuEvent");
                                cmpRefreshLightningMenuEvent.fire();
                                h.closeEditMode_helper(c, e, h);
                            }
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
        } else {
            alert('Enter Name Here.');
        }
    },
    validateEdit_helper: function (c, e, h, recId, recName) {
        c.set('v.openModal', true);
        c.set('v.editMode', true);
        c.set('v.editRecordId', recId);
        c.set('v.recordName', recName);
        window.setTimeout(function () {
            h.hideSpinne_Helper(c, e, h);
        },3000);
    },
    validateDelete_helper: function (c, e, h, recId, sObjectName) {
        try {
            var action = c.get("c.deleteLightningRecord_Apex");
            action.setParams({
                deleteRecordId : recId,
                sObjectName : sObjectName
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        if(resp == 'success') {
                            var cmpRefreshLightningMenuEvent = c.getEvent("cmpRefreshLightningMenuEvent");
                            cmpRefreshLightningMenuEvent.fire();
                        }
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
    closeEditMode_helper: function (c, e, h) {
        c.set('v.openModal', false);
        c.set('v.editMode', false);
        c.set('v.editRecordId', '');
        c.set('v.recordName', '');
        c.set('v.newRecordMode', false);
        c.set('v.newLightningTutorials', false);
        c.set('v.newLightningRecordCreate', {});
        c.set('v.newLightningTutorialsCreate', {});
    },
    saveRecord_helper: function (c, e, h) {
        c.find("edit").get("e.recordSave").fire();
        c.set('v.editMode', false);
        c.set('v.editRecordId', '');
        c.set('v.recordName', '');
        var cmpRefreshLightningMenuEvent = c.getEvent("cmpRefreshLightningMenuEvent");
        cmpRefreshLightningMenuEvent.fire();
    },
    showSpinne_Helper : function(c, e, h) {
        var spinner = c.find("setSpinnerTrueFalse");
		$A.util.removeClass(spinner, 'slds-hide');
		$A.util.addClass(spinner, 'slds-show');
    },
    hideSpinne_Helper : function(c, e, h) {
        var spinner = c.find("setSpinnerTrueFalse");
		$A.util.removeClass(spinner, 'slds-show');
		$A.util.addClass(spinner, 'slds-hide');
    },
})