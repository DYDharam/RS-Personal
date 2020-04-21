({
	getRecord_helper : function(c, e, h) {
        try {
            var jsonData = '';
            
            var action = c.get("c.getDetails_Apex");
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        //console.log('resp-->> ' + JSON.stringify(resp));
                        var categoryList = [];
                        var dataList = [];
                        var dataObj = [];
                        for(var i = 0; i < resp.length; i++) {
                            console.log('resp.accName->> ' + resp[i].accName);
                            categoryList.push(resp[i].accName);
                            dataList.push(resp[i].totalContact);
                            /*var dataObj1 = {};
                            dataObj1.name = categoryList;
                            dataObj1.data = resp[i].totalContact;
                            dataObj.push(dataObj1);*/
                            
                            dataObj[i].push({
                                name: resp[i].accName,
                                data: [15,20,32]
                            });
                        }
                        
                        c.set('v.categoryList', categoryList);
                        jsonData = JSON.stringify();
                        c.set("v.data",jsonData);
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