({
    doInit : function(c, e, h) {
        h.doInit_helper(c, e, h);
    },
    handleOnload : function(c, e, h) {
        
    },
    handleOnSubmit : function(c, e, h) {
        h.doInit_helper(c, e, h);
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
        //h.setCheckBoxTrue_helper(c, e, h);
    },
    saveRecordJS : function(c, e, h) {
        var getAllFieldsList = c.get('v.getAllFieldsList');
        if(!$A.util.isEmpty(getAllFieldsList) && !$A.util.isUndefined(getAllFieldsList)) {
            for(var i = 0; i < getAllFieldsList.length; i++) {
                console.log('getAllFieldsList[i].isRequiredField:: ' + getAllFieldsList[i].isRequiredField);
                if(getAllFieldsList[i].isRequiredField == true && $A.util.isEmpty(getAllFieldsList[i].fieldValue)) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error Message',
                        message: 'Required Field Missing :::: ' + getAllFieldsList[i].fieldLabel,
                        messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    break;
                }
                
                
                
                
                
                if(getAllFieldsList[i].fieldType == 'reference' && !$A.util.isUndefined(getAllFieldsList[i].fieldValue) && !$A.util.isEmpty(getAllFieldsList[i].fieldValue)) {
                    getAllFieldsList[i].fieldValue = getAllFieldsList[i].fieldValue.Id;
                }
            }
            h.saveRecordJS_helper(c, e, h, getAllFieldsList);
        }
    },
})