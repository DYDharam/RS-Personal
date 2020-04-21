({
    accessToken_helper : function(c, e, h, codeJS) {
        try {
            var action = c.get("c.accessToken_Apex");
            action.setParams({
                codeJS : codeJS
            });
            action.setCallback(this, function (response) {
                if(response.getState() === 'SUCCESS') {
                    var resp = response.getReturnValue();
                    
                    
                    if(!$A.util.isEmpty(resp) && !$A.util.isUndefined(resp)) {
                        //c.set("v.OAuth", resp);
                        var columnList = [];
                        var tableDataJS = [];
                        for (var key in resp) {
                            if(resp.hasOwnProperty(key)) {
                                columnList.push({label: key, fieldName: key, type: 'text'});
                            }
                        }
                        var tableVar = {};
                        tableVar.id = '1';
                        for (var i = 0; i < columnList.length; i++) {
                            var obj = columnList[i];
                            tableVar[obj.label] = storedResponse[obj.label];
                        }
                        tableDataJS.push(tableVar);
                        c.set("v.tableColumns", columnList);
                        c.set("v.tableData", tableDataJS);
                    }
                } else {
                    console.log('ERROR');
                    console.log(r.getError());
                }
            });
            $A.enqueueAction(action);
        } catch (ex) {
            console.log(ex);
        }
    },
    authorizeData_helper : function(c, e, h) {
        try {
            var action = c.get("c.getOAuthURL");
            action.setCallback(this, function (r) {
                if(r.getState() === 'SUCCESS') {
                    var storedResponse = r.getReturnValue();
                    console.log('authorize_Helper:');
                    console.log(storedResponse);
                    /*var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": storedResponse,
                        isredirect: true
                    });
                    urlEvent.fire();*/
                    window.location.href = storedResponse;
                } else {
                    console.log('ERROR');
                    console.log(r.getError());
                }
            });
            $A.enqueueAction(action);
        } catch (ex) {
            console.log(ex);
        }
    },
})