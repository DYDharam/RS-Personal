({
	doInit : function(c, e, h) {
	    /* For the Add Question Click */
	    var addQuestionSection = c.get('v.addQuestionSection');
	    if(addQuestionSection) {
	        h.addMoreRecord_helper(c, e, h, true);
	    }
	    // End
    },
	closeMe : function(c, e, h) {
		h.closeMe_helper(c, e, h);
	},
	/* For the Add Question Section Start */
	addOptionRecord : function(c, e, h) {
        h.addMoreRecord_helper(c, e, h, false);
    },
    deleteOptionRecord : function(c, e, h) {
        h.deleteOptionRecord_helper(c, e, h);
    },
    saveQuestionDetails : function(c, e, h) {
        var allValid = c.find('questionName').reduce(function (validSoFar, inputCmp) {
               inputCmp.showHelpMessageIfInvalid();
               return validSoFar && inputCmp.get('v.validity').valid;
           }, true);
           if (allValid) {
           h.saveQuestionDetails_helper(c, e, h);
           } else {
            return;
           }
    },
    /* For the Add Question Section End */
})