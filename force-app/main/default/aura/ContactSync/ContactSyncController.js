({
	doInit : function(c, e, h) {
        var codeJS = c.get("v.code");
        if(!$A.util.isEmpty(codeJS) && !$A.util.isUndefined(codeJS)) {
            //h.accessToken_helper(c, e, h, codeJS);
        }
	},
    authorizeData : function(c, e, h) {
        h.authorizeData_helper(c, e, h);
    },
})