({
	closeModalWindow : function(c, e, h) {
		h.closeModalWindow_helper(c, e, h);
	},
    openTutorialRecord : function(c, e, h) {
        var recId = e.target.id;
        console.log('recId-->>'+recId);
        var lightningTutorialsRecord = {};
        var lightningTutorialsList = c.get('v.lightningTutorialsList');
        if(!$A.util.isEmpty(recId) && recId != undefined &&!$A.util.isEmpty(lightningTutorialsList) && lightningTutorialsList != undefined) {
            for(var i = 0; i < lightningTutorialsList.length; i++) {
                if(lightningTutorialsList[i].Id == recId) {
                    lightningTutorialsRecord.Name = lightningTutorialsList[i].Name;
                    lightningTutorialsRecord.Component_Description__c = lightningTutorialsList[i].Component_Description__c;
                    lightningTutorialsRecord.Description__c = lightningTutorialsList[i].Description__c;
                    lightningTutorialsRecord.Controller_Description__c = lightningTutorialsList[i].Controller_Description__c;
                    lightningTutorialsRecord.Documentation_Description__c = lightningTutorialsList[i].Documentation_Description__c;
                    lightningTutorialsRecord.Event_Description__c = lightningTutorialsList[i].Event_Description__c;
                    lightningTutorialsRecord.Helper_Description__c = lightningTutorialsList[i].Helper_Description__c;
                    lightningTutorialsRecord.Image_Url__c = lightningTutorialsList[i].Image_Url__c;
                    lightningTutorialsRecord.Renderer_Description__c = lightningTutorialsList[i].Renderer_Description__c;
                    lightningTutorialsRecord.Style_Description__c = lightningTutorialsList[i].Style_Description__c;
                    lightningTutorialsRecord.Svg_Description__c = lightningTutorialsList[i].Svg_Description__c;
                    lightningTutorialsRecord.Class_Description__c = lightningTutorialsList[i].Class_Description__c;
                    lightningTutorialsRecord.Visualforce_Description__c = lightningTutorialsList[i].Visualforce_Description__c;
                    lightningTutorialsRecord.App_Description__c = lightningTutorialsList[i].App_Description__c;
                    lightningTutorialsRecord.Component_Name__c = lightningTutorialsList[i].Component_Name__c;
                }
            }
            h.openTutorialRecord_helper(c, e, h, lightningTutorialsRecord);
        }
	},
    searchLightningTutorials : function(c, e, h) {
        var searchVal = c.find('tutorialSearch').get('v.value');
        var lightningTutorialsList = c.get('v.lightningTutorialsList');
        var lightningTutorialsListCopy = c.get('v.lightningTutorialsListCopy');
        console.log('lightningTutorialsListCopy-->>> '+ JSON.stringify(lightningTutorialsListCopy.length));
        if(!$A.util.isEmpty(searchVal) && !$A.util.isEmpty(lightningTutorialsList)) {
            //h.searchLightningTutorials_helper(c, e, h, lightningTutorialsList, searchVal);
        } else {
            //c.set('v.lightningTutorialsList', lightningTutorialsListCopy);
        }
    },
    viewComponent : function(c, e, h) {
        var componentName = e.getSource().get('v.name');
        var url = window.location.hostname;
        url = '/LightningTutorials/s/showcomponent?name=' + componentName;
        window.open(url);
    },
})