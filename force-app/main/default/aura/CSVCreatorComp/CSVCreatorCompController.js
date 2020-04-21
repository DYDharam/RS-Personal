({
    handleUploadFinished : function(component, event, helper) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if(file) {
            console.log("UPLOADED")
            var reader = new FileReader();
            reader.readAsText(file, 'UTF-8');
            reader.onload = function(evt) {
                var csv = evt.target.result;
                component.set("v.csvString", csv);
            }
        }
    },

    handleGetCSV : function(component, event, helper) {
        var csv = component.get("v.csvString");
        if(csv != null) {
            helper.createCSVObject(component, csv);
        }
    },

    cleanData : function(component, event, helper) {
        component.set("v.csvString", null);
        component.set("v.csvObject", null);
    },

    calculateData : function (component, event, helper) {
        var csvObject = component.get('v.csvObject');
        var columnDetails = csvObject.headers;
        var dataDetails = csvObject.lines;
        console.log('columnDetails::: ' + JSON.stringify(columnDetails));
        var accountList = [];
        //for(var accountObj = 0 ; accountObj < columnDetails.length; accountObj++) {
        for(var data = 0; data < dataDetails.length; data++) {
            var newDataList = dataDetails[data];
            var accountObject = {};
            accountObject.Name = newDataList[1];
            //Date mydatses = date.parse(newDataList[2]);
            accountObject.SLAExpirationDate__c = newDataList[2]; //mydatses; //newDataList[2];
            accountObject.Phone = newDataList[3];
            accountObject.Description = newDataList[4];
            accountList.push(accountObject);
        }
        console.log('accountList:::: ' + JSON.stringify(accountList));
        helper.saveAccountDetails_helper(component, event, helper, accountList);
    }

})