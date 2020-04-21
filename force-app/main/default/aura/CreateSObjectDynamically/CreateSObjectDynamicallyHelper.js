({
	doInit_helper : function(c, e, h) {
		var sObjectName = c.get('v.sObjectName');
        var recId = c.get('v.recordId');
        console.log('recId:: ' + recId);
        sObjectName = 'Account';
        c.set('v.sObjectName', sObjectName);
        console.log('sObjectName:: ' + sObjectName);
        if(!$A.util.isEmpty(sObjectName)) {
            if(!$A.util.isEmpty(recId)) {
            	h.getAllField_helper(c, e, h, sObjectName, recId);
            } else {
                h.getAllFields_helper(c, e, h, sObjectName, recId);
            }
        }
	},
    getAllFields_helper : function(c, e, h, sObjectName, recId) {
        try {
            var pageLayoutName = c.get('v.pageLayoutName');
            console.log('pageLayoutName::: ' + pageLayoutName);
            var action = c.get("c.getAllFields_Apex_Copy");
            action.setParams({
                sObjectName : sObjectName,
                recordId : recId,
                pageLayoutName : ''//sObjectName + '-' + pageLayoutName
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state::: ' + state);
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    console.log('resp--->>>'+JSON.stringify(resp));
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        c.set('v.getAllFieldsList', resp);
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
    getAllField_helper : function(c, e, h, sObjectName, recId) {
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
    },
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
            var sObjectName = c.get('v.sObjectName');
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
})