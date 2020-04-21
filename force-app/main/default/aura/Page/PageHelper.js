({
	doInit_helper : function(c, e, h) {
		var url = window.location.href;
        var urlList;
        if(url.includes('s/')) {
            urlList = url.split('s/');
            if(!$A.util.isEmpty(urlList[1])) {
                c.set('v.componentName', urlList[1]);
            }
        }
	},
})