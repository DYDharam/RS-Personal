({
    doInit_Helper : function(c, e, h) {
        var action = c.get('c.Accdata');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                c.set('v.accounts', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})