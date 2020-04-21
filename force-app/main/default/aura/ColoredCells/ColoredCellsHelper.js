({
    doInit_helper : function(c, e, h) {
        try {
            c.set('v.isSpinner', true);
            var action = c.get("c.getRecord_apex");
            /*action.setParams({
                strObjectName : 'Contact'
            });*/
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if((!$A.util.isEmpty(resp)) && (!$A.util.isUndefined(resp))) {
                        console.log('resp-->>> ' + JSON.stringify(resp));
                        var actionsButton = [
                            { label: 'View', name: 'view', 'iconName': 'action:preview' },
                            { label: 'Edit', name: 'edit', 'iconName': 'action:edit' },
                        ];
                            c.set('v.columns', [
                            /*{label: 'Name', fieldName: 'Name', type: 'text'},*/
                            {label: 'Name', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}, sortable: true},
                            /*{label: 'Owner Name', fieldName: 'Owner.name', type: 'text', sortable: true},*/
                            {label: 'Date', fieldName: 'CreatedDate', type: 'date', sortable: true},
                            {label: 'Actual Date', fieldName: 'CreatedDate', type: 'date-local', sortable: true},
                            {label: 'Date Formated', fieldName: 'CreatedDate', type: 'date-local', typeAttributes: {month: 'short', day: 'numeric', year: 'numeric'}, sortable: true},
                            {label: 'Marks', fieldName: 'NumberOfEmployees', type: 'number',  cellAttributes: { alignment: 'left', class: { fieldName: 'NumberOfEmployeesClass' }}, sortable: true},
                            {label: 'Clean Status', fieldName: 'CleanStatus', type: 'text', cellAttributes: { class: { fieldName: 'dietCSSClass' }}, sortable: true},
                            {label: 'Mobile', fieldName: 'Mobile', type: 'text', sortable: true},
                            {label: 'AnnualRevenue', fieldName: 'AnnualRevenue', type: 'currency', typeAttributes: { currencyCode: 'USD'}, cellAttributes: { class: { fieldName: 'fvtColorCSSClass' }}, sortable: true},
                            {label: 'Avg', fieldName: 'NumberOfEmployees', type: 'percent', sortable: true},
                            {label: 'In Working', fieldName: 'Working', type: 'boolean', cellAttributes: { class: { fieldName: 'workingCSSClass' }}, sortable: true},
                            {label: 'Edit', type : 'button', initialWidth: 100, typeAttributes: {label: 'Edit', name: 'edit_button', title: 'Edit Button', class: {fieldName: 'isShow'}}},
                            { type: 'action', typeAttributes: { rowActions: actionsButton } } 
                        ]);
                        
                        
                        c.set('v.data', resp);
                        c.set('v.isSpinner', false);
                    }
                }else if (state === 'ERROR'){
                    var errors = response.getError();
                    c.set('v.isSpinner', false);
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
    loadMoreOffset_helper : function(c, e, h) {
		
	},
    sortColumns_helper : function(c, fieldName, sortDirection) {
        var data = c.get("v.data");
        var reverse = sortDirection !== 'asc';
        if(fieldName == 'Name') {
            data.sort(function(a,b) {
                	return (a.Name.toUpperCase() > b.Name.toUpperCase()) ? 1 : ((b.Name.toUpperCase() > a.Name.toUpperCase()) ? -1 : 0);
            });
        } else {
            data.sort(this.sortBy(fieldName, reverse));
        }
        c.set("v.data", data);
    },
    sortData: function (c, fieldName, sortDirection) {
        var data = c.get("v.data");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        c.set("v.data", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function (x) {
                return primer(x[field])
            } :
            function (x) {
                return x[field]
            };
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a) ? key(a) : '', b = key(b) ? key(b) : '', reverse * ((a > b) - (b > a));
        }
    },
})