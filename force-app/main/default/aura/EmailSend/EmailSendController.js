({
    
    sendMail: function(component, event, helper) {
        
        var getEmail = component.get("v.email");
        
        var getSubject = component.get("v.subject");
        
        var getbody = component.get("v.body"); 
        
        if ($A.util.isEmpty(getEmail) || !getEmail.includes("@")) {
            
            alert('Please Enter valid Email Address');
            
        } else {
            
            helper.sendHelper(component, getEmail, getSubject, getbody);
            
        }
        
    },
    
    closeMessage: function(component, event, helper) {
        
        component.set("v.mailStatus", false);
        
        component.set("v.email", null);
        
        component.set("v.subject", null);
        
        component.set("v.body", null);
        var cmpRefreshLightningMenuEvent = component.getEvent("cmpRefreshLightningMenuEvent");
        cmpRefreshLightningMenuEvent.setParams({
            "notifyClosePopup" : true });
        cmpRefreshLightningMenuEvent.fire();
    },
    
})