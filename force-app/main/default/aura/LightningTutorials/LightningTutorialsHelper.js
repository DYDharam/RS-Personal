({
	closeModalWindow_helper : function(c, e, h) {
		c.set('v.openModalWithDescription', false);
        c.set('v.tutorialName', '');
        c.set('v.tutorialDescription', '');
        c.set('v.lightningTutorialsRecord', {});
	},
    openTutorialRecord_helper : function(c, e, h, lightningTutorialsRecord) {
		c.set('v.openModalWithDescription', true);
        c.set('v.lightningTutorialsRecord', lightningTutorialsRecord);
	},
    searchLightningTutorials_helper : function(c, e, h, lightningTutorialsRecord, searchVal) {
        var OpportunitydataReplica = lightningTutorialsRecord,
            term = searchVal,
            results = OpportunitydataReplica, regex;
        
        regex = new RegExp(term, "i");
        results = OpportunitydataReplica.filter(row=>regex.test(row.Name));
        c.set("v.lightningTutorialsList", results);
	},
    
})