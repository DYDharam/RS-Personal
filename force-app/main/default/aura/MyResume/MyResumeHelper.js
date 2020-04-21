({
	doInit_helper : function(c, e, h) {
        h.getTestimonialsRecords_helper(c, e, h);
	},
	getTestimonialsRecords_helper : function (c, e, h) {
        try {
           var action = c.get("c.getTestimonialsRecord_Apex");
           /*action.setParams({
              strObjectName : 'Contact'
           });*/
           action.setCallback(this, function(response){
              var state = response.getState();
              if(state === 'SUCCESS'){
                 var resp = response.getReturnValue();
                 console.log('resp-->> '+JSON.stringify(resp));
                 if(!$A.util.isEmpty(resp) && resp != undefined) {
                        c.set('v.testimonialList', resp);
                        var newTestimonialObj = {};
                        for(var i = 0; i < resp.length; i++) {
                            newTestimonialObj = resp[0];
                        }
                        c.set('v.newTestimonialObj', newTestimonialObj);
                        c.set('v.currentTestimonialRecord', 0);
                        c.set('v.totalTestimonialRecord', resp.length);
                   } else {
                        c.set('v.testimonialList', []);
                        c.set('v.newTestimonialObj', {});
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
	},
	nextSlide_helper : function (c, e, h) {
	    var testimonialList = c.get('v.testimonialList');
	    var currentTestimonialRecord = c.get('v.currentTestimonialRecord');
	    currentTestimonialRecord += 1;
	    if(!$A.util.isEmpty(testimonialList) && testimonialList != undefined) {
	        var newTestimonialObj = {};
	        for(var i = 0; i < testimonialList.length; i++) {
	            if(i == currentTestimonialRecord) {
	                newTestimonialObj = testimonialList[i];
	            }
	        }
	        c.set('v.newTestimonialObj', newTestimonialObj);
            c.set('v.currentTestimonialRecord', currentTestimonialRecord);
	    }
	},
	previousSlide_helper : function (c, e, h) {
        var testimonialList = c.get('v.testimonialList');
        var currentTestimonialRecord = c.get('v.currentTestimonialRecord');
        currentTestimonialRecord -= 1;
        if(!$A.util.isEmpty(testimonialList) && testimonialList != undefined) {
            var newTestimonialObj = {};
            for(var i = 0; i < testimonialList.length; i++) {
                if(i == currentTestimonialRecord) {
                    newTestimonialObj = testimonialList[i];
                }
            }
            c.set('v.newTestimonialObj', newTestimonialObj);
            c.set('v.currentTestimonialRecord', currentTestimonialRecord);
        }
    },
})