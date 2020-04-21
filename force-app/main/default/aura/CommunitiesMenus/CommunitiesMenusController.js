({
	/*handleActiveJS: function (c, e, h) {
        h.lazyLoadTabs(c, e, h);
    },*/
    doInit: function (c, e, h) {
        //getLightningTutorials_Apex
        h.doInit_helper(c, e, h);
        
        //h.doInit_helper(c, e, h);
        //h.getLightingDetail_helper(c, e, h);
        //h.getLightingTutorialsDetail_helper(c, e, h);
    },
    updateCount: function (c, e, h) {
        var socialType = e.target.title
        if(!$A.util.isEmpty(socialType) && socialType != undefined) {
            h.updateCount_helper(c, e, h, socialType);
        }
    },
})