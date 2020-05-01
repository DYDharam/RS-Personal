({
	doInit_helper : function(c, e, h) {
		var sObjectName = c.get('v.sObjectName');
        var recId = c.get('v.recordId');
        c.set('v.sObjectName', 'Account');
        console.log('sObjectName:: ' + sObjectName);
        //h.getAllFields_helper(c, e, h, sObjectName, recId);
        h.getSObjectPickListValue_helper(c, e, h);
	},
    getSObjectPickListValue_helper : function(c, e, h) {
        try {
            var action = c.get("c.getSobjectList_Apex");
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state::: ' + state);
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    console.log('resp;:: ' + JSON.stringify(resp));
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        resp.sort(function(a,b) {
                            return (a.label.toUpperCase() > b.label.toUpperCase()) ? 1 : ((b.label.toUpperCase() > a.label.toUpperCase()) ? -1 : 0);
                        });
                        c.set('v.sObjectOptions', resp);
                        c.set('v.isSObjectNameLoaded', true);
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
    getAllFields_helper : function(c, e, h, sObjectName, recId) {
        try {
            var pageLayoutName = c.get('v.pageLayoutName');
            var action = c.get("c.getAllFields_Apex");
            action.setParams({
                sObjectName : sObjectName,
                recordId : recId//,
                //pageLayoutName : '' //sObjectName + '-' + pageLayoutName
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state::: ' + state);
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        c.set('v.getAllFieldsList', resp);
                        c.set('v.isComponentLoaded', true);
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
    /*getAllField_helper : function(c, e, h, sObjectName, recId) {
        try {
            var action = c.get("c.getAllFields");
            action.setParams({
                sObjectName : 'Contact',
                recordId : recId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    console.log('resp--->>>'+JSON.stringify(resp));
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        c.set('v.getAllFieldsName', resp);
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
    },*/
    saveRecordJS_helper : function(c, e, h, getAllFieldsList) {
        console.log('getAllFieldsList::: ' + JSON.stringify(getAllFieldsList));
        var newListForInsert = [];
        if(!$A.util.isEmpty(getAllFieldsList.length) && !$A.util.isUndefined(getAllFieldsList.length) && getAllFieldsList.length != 0) {
            var str = '{';
            for(var i = 0; i < getAllFieldsList.length; i++) {
                if(!$A.util.isEmpty(getAllFieldsList[i].fieldValue) && !$A.util.isUndefined(getAllFieldsList[i].fieldValue)) {
                    var newObjForInsert = {};
                    console.log('INNNNN');
                    str += '"' + getAllFieldsList[i].fieldApiName + '":"' + getAllFieldsList[i].fieldValue + '",';
                }                
            }
            var lastChar = str[str.length -1];
            if(str[str.length -1] == ',') {
                str = str.slice(0, -1);
            }
            str += '}';
            newListForInsert.push(JSON.parse(str));
            if(str != '{}') {
                var newStr = '[' + str + ']';
                h.saveRecordApex_helper(c, e, h, newListForInsert);
            }
        }
    },
    saveRecordApex_helper : function(c, e, h, sObjectListAsString) {
        try {
            console.log('newStr:::L' + JSON.stringify(sObjectListAsString));
            var sObjectName = c.get('v.seletedSobjectName');
            sObjectName = 'List<' + sObjectName + '>';
            console.log('sObjectName::: ' + sObjectName);
            var action = c.get("c.saveSobjectRecord_Apex");
            action.setParams({
                sObjectListAsString : JSON.stringify(sObjectListAsString),
                typeOfList : sObjectName
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state;:: ' + state);
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    console.log('resp-FFF-->>>'+JSON.stringify(resp));
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success Message',
                            message: 'Mode is pester ,duration is 5sec and this is normal Message',
                            messageTemplate: 'Record {0} created! See it {1}!',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
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
    notification_message : function (c, e, h, errroTitle, errorMsg, errorType) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : errroTitle,
            message: errorMsg,
            messageTemplate: '',
            duration:' 5000',
            key: 'info_alt',
            type: errorType,
            mode: 'pester'
        });
        toastEvent.fire();
    },
})