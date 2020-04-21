({
	doInit : function (c, e, h){
		h.doInit_Helper(c, e, h);
	},
    confirmLoginJS : function (c, e, h){
        h.confirmLoginJS_Helper(c, e, h);
    },
    LogoutEvent : function (c, e, h){
        var LogoutEventHelper = c.getEvent("LogoutEvent");
        LogoutEventHelper.fire();
    },
    LogoutEvent : function(c, e, h){
        c.set("v.loginStatus", false);
    },
})