({
	doInit : function(c, e, h) {
		var recordId = c.get('v.recordId');
        if(!$A.util.isEmpty(recordId) && recordId != undefined) {
            h.doInit_helper(c, e, h, recordId);
        }
	},
})