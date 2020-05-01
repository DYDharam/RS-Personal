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
    setCheckBoxTrue : function(c, e, h) {
        var isCheckBoxTrue = e.target.checked;
        console.log('isCheckBoxTrue::: ' + isCheckBoxTrue);
        var getAllFieldsList = c.get('v.getAllFieldsList');
        if(!$A.util.isEmpty(getAllFieldsList) && !$A.util.isUndefined(getAllFieldsList)) {
            for(var i = 0; i < getAllFieldsList.length; i++) {
                if(getAllFieldsList[i].fieldType == 'boolean' && isCheckBoxTrue == true) {
                    getAllFieldsList[i].fieldValue = true;
                } else if(getAllFieldsList[i].fieldType == 'boolean' && isCheckBoxTrue == false) {
                    getAllFieldsList[i].fieldValue = false;
                }
            }
        }
        console.log('newStr:::L' + JSON.stringify(getAllFieldsList));
        h.setCheckBoxTrue_helper(c, e, h);
    },
    saveRecordJS : function(c, e, h) {
        var getAllFieldsList = c.get('v.getAllFieldsList');
        if(!$A.util.isEmpty(getAllFieldsList) && !$A.util.isUndefined(getAllFieldsList)) {
            for(var i = 0; i < getAllFieldsList.length; i++) {
                console.log('getAllFieldsList[i].isRequiredField:: ' + getAllFieldsList[i].isRequiredField);
                if(getAllFieldsList[i].isRequiredField == true && $A.util.isEmpty(getAllFieldsList[i].fieldValue)) {
                    var msg = 'Required Field Missing : ' + getAllFieldsList[i].fieldLabel;
                    h.notification_message(c, e, h, 'Error Message', msg, 'error');
                    break;
                }
            }
            for(var i = 0; i < getAllFieldsList.length; i++) {
                if(getAllFieldsList[i].fieldType == 'reference' && !$A.util.isUndefined(getAllFieldsList[i].fieldValue) && !$A.util.isEmpty(getAllFieldsList[i].fieldValue)) {
                    getAllFieldsList[i].fieldValue = getAllFieldsList[i].fieldValue.Id;
                }
            }
            h.saveRecordJS_helper(c, e, h, getAllFieldsList);
        }
    },
})