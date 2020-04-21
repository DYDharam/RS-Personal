({
    lightningTutorialsSelect : function(c, e, h) {
        var parcedValue = e.getParam("value").split(',');
        var Id = parcedValue[0];
        var label = parcedValue[1];
        var name = parcedValue[2];
        if((!$A.util.isEmpty(Id)) && (Id != undefined) && (!$A.util.isEmpty(name)) && (name != undefined)) {
            if(label === 'edit') {
                h.showSpinne_Helper(c, e, h);
                h.validateEdit_helper(c, e, h, Id, name);
            } else if(label === 'delete') {
                h.validateDelete_helper(c, e, h, Id, 'Lightning_Videos__c');
            }
        }
	},
    lightningTutorials : function(c, e, h) {
        var parcedValue = e.getParam("value").split(',');
        var Id = parcedValue[0];
        var label = parcedValue[1];
        var name = parcedValue[2];
        if((!$A.util.isEmpty(Id)) && (Id != undefined) && (!$A.util.isEmpty(name)) && (name != undefined)) {
            if(label === 'edit') {
                h.showSpinne_Helper(c, e, h);
                h.validateEdit_helper(c, e, h, Id, name);
            } else if(label === 'delete') {
                h.validateDelete_helper(c, e, h, Id, 'Lightning_Tutorials__c');
            }
        }
	},
    createRecord : function(c, e, h) {
        h.createRecord_helper(c, e, h, 'Lightning_Videos__c');
	},
    createRecordTutorials : function(c, e, h) {
        h.createRecord_helper(c, e, h, 'Lightning_Tutorials__c');
	},
    closeEditMode : function(c, e, h) {
        h.closeEditMode_helper(c, e, h, 'Lightning_Videos__c');
	},
    saveRecord : function(c, e, h) {
        h.saveRecord_helper(c, e, h);
	},
    createLightningRecord : function(c, e, h) {
        h.createLightningRecord_helper(c, e, h, 'Lightning_Videos__c');
	},
    createLightningTutorials : function(c, e, h) {
        h.createLightningRecord_helper(c, e, h, 'Lightning_Tutorials__c');
	},
})