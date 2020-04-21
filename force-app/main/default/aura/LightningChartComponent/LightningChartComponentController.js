({
	doInit : function(component, event, helper) {
        helper.getRecord_helper(component, event, helper);
        //var categoryList = [];
        //categoryList.push('ONe', 'Two', 'Three');
        //component.set('v.categoryList', categoryList);
        /*var jsonData = '';
        var dataObj = [];
        dataObj[0] = {
            name: 'MTD 2016',
            data: [15,25,35]
        };
        dataObj[1] = {
            name: 'Prior Year',
            data: [10,35,45]
        };
        dataObj[2] = {
            name: 'Next Year',
            data: [15,20,32]
        };
        jsonData = JSON.stringify(dataObj);
        component.set("v.data",jsonData);*/
        
        //component.find("compId").set("v.data", jsonData);
    },
    onInitLookup : function(c, e, h) 
    {
        var newList = [];
        for(var i = 0; i < 10; i++) {
            var newObj = {};
            newObj.Id = '879868999'+i;
            newObj.Name = 'NEW Account' + i;
            
            newList.push(newObj);
        }
        c.set('v.listOfSearchRecords', newList);
    },
})