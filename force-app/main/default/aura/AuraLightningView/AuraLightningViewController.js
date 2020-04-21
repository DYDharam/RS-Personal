({
	doInit : function(c, e, h) {
		var url = window.location.href;
        var urlList;
        if(url.includes('?Id=')) {
            urlList = url.split('?Id=');
            if(!$A.util.isEmpty(urlList[1])) {
                c.set('v.isRunComponent', true);
                h.doInit_helper(c, e, h, urlList[1]);
            }
        } else if(url.includes('view?name=')) {
            urlList = url.split('view?name=');
            if(!$A.util.isEmpty(urlList[1])) {
                c.set('v.componentName', urlList[1]);
            }
        }
	},
    viewComponent : function(c, e, h) {
        var componentName = e.getSource().get('v.name');
        var url = window.location.hostname;
        url = '/s/showcomponent?name=' + componentName;
        window.open(url);
    },
})