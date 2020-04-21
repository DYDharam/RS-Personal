({
    doInit : function (c, e, h) {
        h.doInit_helper(c, e, h);
    },
    closeModalPopup : function (c, e, h) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
    onValidateEndorsementObject : function (c, e, h) {
        var endorsementObject = c.get('v.endorsementObjectToInsert');
        var policyObjectInfo = c.get('v.policyObjectInfo');
        //console.log('endorsementObject-->>> '+JSON.stringify(endorsementObject));CanaryAMS__Premium_Change__c
        //console.log('policyObjectInfo-->>> '+JSON.stringify(policyObjectInfo));
        var endorsementPremium = c.get('v.endorsementPremium');
        var effectiveDate = c.get('v.effectiveDate');
        if($A.util.isEmpty(endorsementObject.Type__c) || endorsementObject.Type__c === undefined) {
            c.set('v.isMessage', true);
            c.set('v.errorMessage', 'Please Select Any Reason.');
            window.setTimeout(function () {
                h.closeToast_helper(c, e, h);
            },5000);
        } else {
            h.updatePolicyAndInsertEndorsement_helper(c, e, h, policyObjectInfo, endorsementObject, endorsementPremium, effectiveDate);
        }
    },
    closeToast : function (c, e, h) {
        h.closeToast_helper(c, e, h);
    },
})