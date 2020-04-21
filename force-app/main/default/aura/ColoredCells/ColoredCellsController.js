({
    doInit : function(c, e, h) {
        h.doInit_helper(c, e, h);
    },
    loadMoreOffset : function(c, e, h) {
        /*h.fetchData_helper(c, c.get('v.rowsToLoad'), 'Policy', '').then($A.getCallback(function (data) {
            if (c.get('v.policyList').length == 0) {
                c.set('v.enableInfiniteLoading', false);
                c.set('v.loadMoreStatusPolicy', 'No more data to load');
            } else {
                var currentData = c.get('v.policyList');
                //Appends new data to the end of the table
                var newData = currentData.concat(data);
                c.set('v.policyList', newData);
                c.set('v.loadMoreStatusPolicy', 'Please wait ');
            }
            e.getSource().set("v.isLoading", false);
        }));*/
    },
    onRowSelectionJs : function (c, e, h) {
        var selectedRows = e.getParam('selectedRows');
        alert(selectedRows[0].Name);
    },
    handleRowAction: function(c,e,h){
        var action = e.getParam('action');
        var row = e.getParam('row');
        switch (action.name) {
            case 'view':
                alert('View : Account Name is - ' + row.Name);
                break;
            case 'edit':
                alert('Edit : Account Name is - ' + row.Name);
                break;
            case 'edit_button':
                alert('Edit Button : Account Name is - ' + row.Name);
                break;
        }
    },
    sortColumns: function(c, e, h){
        var fieldName = e.getParam('fieldName');
        var sortDirection = e.getParam('sortDirection');
        c.set("v.sortedBy", fieldName);
        c.set("v.sortedDirection", sortDirection);
        h.sortColumns_helper(c, fieldName, sortDirection);
    },
})