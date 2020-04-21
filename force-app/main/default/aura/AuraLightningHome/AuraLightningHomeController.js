({
	doInit : function(c, e, h) {
		h.doInit_helper(c, e, h);
        
	},
    viewRecord : function(c, e, h) {
		h.viewRecord_helper(c, e, h);
	},
    viewRecords : function(c, e, h) {
		h.viewRecords_helper(c, e, h);
	},
	handleLikeButtonClick : function(c, e, h) {
		var getSelected = e.getSource().get('v.selected');
		var getId = e.getSource().get('v.name');
		//console.log('getSelected-- ' + getSelected);
		//console.log('getId-- ' + getId);
		var setSelected = e.getSource().set('v.selected', !getSelected);
		if(!getSelected) {
			h.likeButtonHit_helper(c, e, h, getId);
		} else {
			//console.log('ELSEEE');
		}
		
	},
    goPrevious : function(c, e, h) {
		var limits = c.get('v.limits');
        var offsets = c.get('v.offsets');
        offsets -= 10;
		h.getTutorial_helper(c, e, h, limits, offsets, false, true);
	},
    goNext : function(c, e, h) {
        var limits = c.get('v.limits');
        var offsets = c.get('v.offsets');
        offsets += 10;
		h.getTutorial_helper(c, e, h, limits, offsets, true, false);
	},
})