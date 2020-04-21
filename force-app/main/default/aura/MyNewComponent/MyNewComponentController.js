({
    myAction : function(component, event, helper) {
        var evt = component.getEvent("event");
        evt.setParams({
            "text" : "HELLo"
        });
        evt.fire();
    },
    evtAction : function(component, event, helper) {
        var message = event.getParam("text"); 
        alert(message);
        
    }
})