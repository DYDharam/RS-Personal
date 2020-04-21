({
    doInit : function(component, event, helper) {
        var sObjectName = component.get('v.sObjectName');
        helper.getTotalNumberOfSobject(component,sObjectName);
        helper.getColumnAndAction(component);
        helper.getRecords(component, event, helper, sObjectName);
    },
     
    handleLoadMoreContacts: function (component, event, helper) {
        event.getSource().set("v.isLoading", true);
        component.set('v.loadMoreStatus', 'Loading....');
        var sObjectName = component.get('v.sObjectName');
        helper.getMoreSobjectRecords(component, component.get('v.rowsToLoad'), sObjectName).then($A.getCallback(function (data) {
            if (parseInt(component.get('v.data').length) >= parseInt('30')) {
                component.set('v.enableInfiniteLoading', false);
                component.set('v.loadMoreStatus', 'No more data to load');
            } else {
                var currentData = component.get('v.data');
                var newData = currentData.concat(data);
                component.set('v.data', newData);
                component.set('v.loadMoreStatus', 'Please scroll down to load more data');
            }
            event.getSource().set("v.isLoading", false);
        }));
    },
     
    handleSelectedRows: function (component, event, helper) {
        var data = component.get('v.data');
        var selectedRowList =  component.get("v.selectedRowsList");
        console.log('selectedRowList-' + selectedRowList);
    },
     
    handleSelectedRow: function(component, event, helper){
        var selectedRows = event.getParam('selectedRows');
        component.set("v.selectedRowsCount", selectedRows.length);
        let obj =[] ; 
        for (var i = 0; i < selectedRows.length; i++){
            obj.push({Name:selectedRows[i].Name});
        }
        component.set("v.selectedRowsDetails", JSON.stringify(obj) );
        component.set("v.selectedRowsList", event.getParam('selectedRows'));
    },
     
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'new':
                helper.createContactRecord(component, event);
                break;
            case 'edit':
                helper.editContactRecord(component, event);
                break;
            case 'delete':
                helper.deleteContactRecord(component, event);
                break;
            case 'view':
                helper.viewContactRecord(component, event);
                break;
        }
    },
     
    handleColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
})