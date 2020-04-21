({
	doInit_helper : function(c, e, h) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        c.set("v.effectiveDate", today);
        var recordId = c.get('v.recordId');
        h.getCurrentPolicyRecord_helper(c, e, h, recordId);
        /*var policyObject = {};
        policyObject.CanaryAMS__Net_Premium__c = 300.35;
        policyObject.CanaryAMS__Effective_Date__c = '3/6/2020';
        c.set('v.policyObjectInfo', policyObject);
        console.log('policyObject-->> '+JSON.stringify(policyObject));

        if(!$A.util.isEmpty(policyObject.CanaryAMS__Net_Premium__c) && policyObject.CanaryAMS__Net_Premium__c != undefined) {
            c.set('v.endorsementPremium', policyObject.CanaryAMS__Net_Premium__c);
        } else {
            c.set('v.endorsementPremium', parseInt('0'));
        }*/
	},
	getCurrentPolicyRecord_helper : function(c, e, h, recordId) {
    	try {
        	var action = c.get("c.getCurrentPolicy_Apex");
        	action.setParams({
        		policyId : recordId
        	});
        	action.setCallback(this, function(response){
        		var state = response.getState();
        		if(state === 'SUCCESS'){
        			var resp = response.getReturnValue();
                    console.log('resp-POL->>>'+JSON.stringify(resp));
        			if(!$A.util.isEmpty(resp) && resp != undefined) {
                        c.set('v.policyObjectInfo', resp);
                        if(!$A.util.isEmpty(resp.CanaryAMS__Net_Premium__c) && resp.CanaryAMS__Net_Premium__c != undefined) {
                            c.set('v.endorsementPremium', resp.CanaryAMS__Net_Premium__c);
                        } else {
                            c.set('v.endorsementPremium', parseInt('0'));
                        }
                    } else {
                        c.set('v.policyObjectInfo', {});
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
    closeToast_helper : function(c, e, h) {
        c.set('v.isMessage', false);
        c.set('v.successMessage', '');
        c.set('v.errorMessage', '');
    },
    updatePolicyAndInsertEndorsement_helper : function(c, e, h, policyObjectInfo, endorsementObject, endorsementPremium, effectiveDate) {
        console.log('policyObjectInfo'+JSON.stringify(policyObjectInfo));
        console.log('endorsementObject'+JSON.stringify(endorsementObject));
        console.log('endorsementPremium->>'+endorsementPremium);
        console.log('effectiveDate->>'+effectiveDate);
        var recordId = c.get('v.recordId');
        try {
            var action = c.get("c.insertEndorsementAndUpdatePolicy_Apex");
            action.setParams({
                endorsementObject : endorsementObject,
                policyObjectInfo : policyObjectInfo,
                endorsementPremium : endorsementPremium,
                effectiveDate : effectiveDate
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    console.log('resp--->>> '+resp);
                    if(!$A.util.isEmpty(resp) && resp != undefined && resp == 'inserted_updated') {
                        h.getCurrentPolicyRecord_helper(c, e, h, recordId);
                        c.set('v.isMessage', true);
                        c.set('v.successMessage', 'Record is successfully inserted/updated.');
                        window.setTimeout(function () {
                            h.closeToast_helper(c, e, h);
                        },5000);
                    }
                }else if (state === 'ERROR'){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                            c.set('v.isMessage', true);
                            c.set('v.errorMessage', errors[0].message);
                            window.setTimeout(function () {
                                h.closeToast_helper(c, e, h);
                            },5000);
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