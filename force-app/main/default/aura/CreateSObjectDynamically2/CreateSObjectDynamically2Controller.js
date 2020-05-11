({
    doInit : function(c, e, h) {
        h.doInit_helper(c, e, h);
    },
    handleOnload : function(c, e, h) {
        
    },
    handleOnSubmit : function(c, e, h) {
        h.doInit_helper(c, e, h);
    },
    selectSobject : function(c, e, h) {
        var sObjectName = c.get('v.seletedSobjectName');
        h.getAllFields_helper(c, e, h, sObjectName, '');
    },
    percentChange : function(c, e, h) {
        var getLabel = e.getSource().get('v.label');
        var getValue = e.getSource().get('v.value');
    },
    setCheckBoxTrue : function(c, e, h) {
        var isCheckBoxTrue = e.target.checked;
        var fieldLabel = e.target.id;
        var getAllFieldsList = c.get('v.getAllFieldsList');
        if(!$A.util.isEmpty(getAllFieldsList) && !$A.util.isUndefined(getAllFieldsList)) {
            for(var i = 0; i < getAllFieldsList.length; i++) {
                if(getAllFieldsList[i].fieldLabel == fieldLabel && isCheckBoxTrue == true) {
                    getAllFieldsList[i].fieldValue = true;
                } else if(getAllFieldsList[i].fieldLabel == fieldLabel && isCheckBoxTrue == false) {
                    getAllFieldsList[i].fieldValue = false;
                }
            }
        }
        //h.setCheckBoxTrue_helper(c, e, h);
    },
    saveRecordJS : function(c, e, h) {
        //c.set('v.isSpinnerRunning', false);
        var getAllFieldsList = c.get('v.getAllFieldsList');
        if(!$A.util.isEmpty(getAllFieldsList) && !$A.util.isUndefined(getAllFieldsList)) {
            for(var i = 0; i < getAllFieldsList.length; i++) {
                if(getAllFieldsList[i].isRequiredField == true && $A.util.isEmpty(getAllFieldsList[i].fieldValue)) {
                    var msg = 'Required Field Missing : ' + getAllFieldsList[i].fieldLabel;
                    console.log(':: > ' + msg);
                    h.notification_message(c, e, h, 'Error Message', msg, 'error');
                    break;
                }
                // Check the percent value is greater than 100.
                if(getAllFieldsList[i].fieldType == 'percent' && !$A.util.isEmpty(getAllFieldsList[i].fieldValue) && getAllFieldsList[i].fieldValue > 100) {
                    var msg = 'The ' + getAllFieldsList[i].fieldLabel + ' value cannot be more than 100!!';
                    h.notification_message(c, e, h, 'Error Message', msg, 'error');
                    break;
                }
            }
            for(var i = 0; i < getAllFieldsList.length; i++) {
                // Added for the if any field is Lookup type and assign to value.
                if(getAllFieldsList[i].fieldType == 'reference' && !$A.util.isUndefined(getAllFieldsList[i].fieldValue) && !$A.util.isEmpty(getAllFieldsList[i].fieldValue)) {
                    getAllFieldsList[i].fieldValue = getAllFieldsList[i].fieldValue.Id;
                }
                // Added for the if any field is Multi Select Pick List type and assign to value.
                if(getAllFieldsList[i].fieldType == 'multipicklist') {
                    var selectedPickListValue = "";
                    selectedPickListValue = getAllFieldsList[i].fieldValue;
                    selectedPickListValue = selectedPickListValue.toString(2);
                    var newList = [];
                    var selectedValue = '';
                    if(selectedPickListValue.includes(',')) {
                        newList = selectedPickListValue.split(',');
                        for(var j = 0; j < newList.length; j++) {
                            selectedValue = selectedValue + newList[j] + ';';
                        }
                    } else {
                        selectedValue = selectedPickListValue;
                    }
                    getAllFieldsList[i].fieldValue = selectedValue;
                }
            }
            h.saveRecordJS_helper(c, e, h, getAllFieldsList);
        }
    },
})