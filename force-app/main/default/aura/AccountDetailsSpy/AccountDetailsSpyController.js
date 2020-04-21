({
	handleMessage : function(c, e, h) {
		const param = e.getParam('message');
		console.log(`Account "${param.sobject.Name}" with Id ${param.sobject.Id} is ${param.event.type}!!`);
	},
    updateAccountPhone : function(c, e, h) {
        h.updateAccountPhone_helper(c, e, h);
    },
})