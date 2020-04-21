({
	doInit_helper : function(c, e, h) {
		//h.getLightingDetail_helper(c, e, h);
	},
    openVideoUrl_helper : function(c, e, h) {
		var domainUrl = c.get('v.domainUrl');
        console.log('domainUrl-->>>'+domainUrl);
        var videoUrl = e.target.id;
        console.log('videoUrl-->>'+videoUrl);
        window.open(videoUrl,'_blank');
	},
    /*getLightingDetail_helper : function(c, e, h) {
        try {
            var action = c.get("c.getLightningList_Apex");
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state--<<<'+JSON.stringify(state));
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    console.log('resp--<<<'+JSON.stringify(resp));
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        c.set('v.lightningVideosList', resp);
                    } else {
                        c.set('v.lightningVideosList', []);
                    }
                }else if (state === 'ERROR'){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }else{
                    console.log('Something went wrong, Please check with your admin');
                }
            });
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }
	},*/
})