({
	/**
	 * Search an SObject for a match
	 */
	search : function(c, e, h) {
		h.doSearch(c);
	},

	/**
	 * Select an SObject from a list
	 */
	select: function(c, e, h) {

		h.handleSelection(c, e);
	},

	/**
	 * Clear the currently selected SObject
	 */
	clear: function(c, e, h) {

		h.clearSelection(c);
		e.preventDefault();
		return false;
	},

	/**
	 * If the input is requred, check if there is a value on blur
	 * and mark the input as error if no value
	 */
	handleBlur: function (c, e, h) {

		h.handleBlur(c);
	},

	init : function(c, e, h){
		try{
            
			//first load the current value of the lookup field
			if(c.get("v.multi")) {
				h.getAllAvailableObjectsHelper_Lookup(c, e, h);
				h.changeSettingsHelper(c, e, h);
			}
			h.init(c);
			h.loadFirstValue(c);

		}catch(ex){
			console.log(ex);
		}
	},
	changeLookup: function (c, e, h) {
		h.changeLookupHelper(c, e, h);
	},
	refreshLookupField: function (c, e, h) {
		console.log('refreshLookupField');
		h.clearSelection(c);
		h.changeLookupHelper(c, e, h);
	},
	refreshLookupsObjectAPIName: function (c, e, h) {
		//console.log('refreshLookupsObjectAPIName');
		h.loadFirstValue(c);
	}
})