({
	doInit_helper : function(c, e, h) {
        c.set('v.limits', parseInt(10));
        c.set('v.offsets', parseInt('0'));
		h.getTutorial_helper(c, e, h, 10, 0, false, false);
        
	},
    
	getTutorial_helper : function(c, e, h, limits, offsets, isNext, isPrev) {
        try {
            c.set('v.isSpinner', true);
            var action = c.get("c.getFinalAllTutorialList_Apex");
            //Integer limits, Integer offsets
            action.setParams({
                limits : parseInt(limits),
                offsets : parseInt(offsets)
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp.tutorialList) && resp.tutorialList != undefined) {
                        c.set('v.lightningTutorialsList', resp.tutorialList);
                        if(resp.tutorialList.length != 10) {
                            c.set('v.isNextDisabled', true);
                        } else {
                            c.set('v.isNextDisabled', false);
                        }
                        if(isNext) {
                            c.set('v.offsets', offsets);
                        } 
                        if(isPrev) {
                            c.set('v.offsets', offsets);
                        }
                    } else {
                    	c.set('v.lightningTutorialsList', []);
                    }
                    if(!$A.util.isEmpty(resp.videoTutorialList) && resp.videoTutorialList != undefined) {
                        c.set('v.lightningVideoTutorialsList', resp.videoTutorialList);
                    } else {
                    	c.set('v.lightningVideoTutorialsList', []);
                    }
                    /*window.setTimeout(function () {
                        $('.owl-carousel').owlCarousel({
                            loop:true, // For Continues after finish.
                            margin:10, // Spacing between slides.
                            nav:true, // Next or Prev Buttons
                            responsive:{
                                0:{
                                    items:1 // Divs on the screen on different screen sizes.
                                },
                                600:{
                                    items:3
                                },
                                1000:{
                                    items:5
                                }
                            }
                        })
                        c.set('v.isSpinner', false);
                    },3000);*/
                    //h.autoClickNextSlide_helper(c, e, h);
                    c.set('v.isSpinner', false);
                }else if (state === 'ERROR'){
                    c.set('v.isSpinner', false);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                    c.set('v.lightningTutorialsList', []);
                }else{
                    console.log('Something went wrong, Please check with your admin');
                }
            });
            $A.enqueueAction(action);
        } catch(ex){
            console.log(ex);
        }
    },
    viewRecord_helper : function(c, e, h) {
		var getId = e.getSource().get('v.name');
        console.log('getId :: ' + getId);
        window.open('view?Id='+getId);
	},
    viewRecords_helper : function(c, e, h) {
		var getId = e.target.id;
        console.log('getId :: ' + getId);
        window.open('view?Id='+getId);
	},
    likeButtonHit_helper : function(c, e, h, lookupOfTutorial) {
        try {
            var action = c.get("c.addRecordToHitLike_Apex");
            action.setParams({
                lookupOfTutorial : lookupOfTutorial
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    var resp = response.getReturnValue();
                    if(!$A.util.isEmpty(resp) && resp != undefined) {
                        console.log('resp-->>'+JSON.stringify(resp));
                    } else {
                        
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
    goNext_helper : function(c, e, h) {
        var startPoint = c.get('v.startPoint');
        startPoint = startPoint + 10;
        var endPoint = c.get('v.endPoint');
        var completeList = c.get('v.lightningTutorialsListBackup');
        var newList = [];
        var count = 0;
        if(!$A.util.isEmpty(completeList) && completeList != undefined) {
            for(var i = 0; i < completeList.length; i++) {
                if(i > parseInt(startPoint) && count < 10) {
                    newList.push(completeList[startPoint + i]);
                    count++;
                }
            }
            c.set('v.lightningTutorialsList', newList);
            c.set('v.startPoint', startPoint + 10);
        }
    },
    goPrevious_helper : function(c, e, h) {
        var startPoint = c.get('v.startPoint');
        startPoint = startPoint - 10;
        var endPoint = c.get('v.endPoint');
        var completeList = c.get('v.lightningTutorialsListBackup');
        var newList = [];
        var count = 0;
        if(!$A.util.isEmpty(completeList) && completeList != undefined) {
            for(var i = 0; i < completeList.length; i++) {
                if(i > parseInt(startPoint) && count < 10) {
                    newList.push(completeList[startPoint + i]);
                    count++;
                }
            }
            c.set('v.lightningTutorialsList', newList);
            c.set('v.startPoint', startPoint - 10);
        }
    },
    autoClickNextSlide_helper : function(c, e, h) {
        
        
            /*$("button").click(function(){
                
                console.log('Inn');
                h.autoClickNextSlide_helper(c, e, h);
                
                
            });  
        window.setTimeout(function () {
        },3000);*/
        //document.getElementsByClassName("owl-next").click();
        //clickEvt.click();
        
        
    },
})