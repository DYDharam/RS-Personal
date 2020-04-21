({
    /**
     * This function makes a handshake request to server using current user's session id
     * Once  the handshake is complete, susbcribe to the channel
     * */
    doInit: function(component, event, helper) {
        var action = component.get("c.getSessionId");
        action.setCallback(this, function(response) {
            var sessionId = response.getReturnValue();
            if($A.util.isEmpty(sessionId) || sessionId == undefined) {
                sessionId = '00D7F000002DYHi!ARwAQG9tie31kNB2EMKQDp7DVXw_9aK9x7vYXwstbnjeMdZ4xOh7BHi6FQUw7yj8YxqZC19SzeI42LT223ieMBTae1EKMhgw';
            }
            console.log('sessionId-->> ' + sessionId);
            var resourceFile = new window.org.cometd.CometD();
            resourceFile.configure({
                url: window.location.protocol + '//' + window.location.hostname + '/cometd/41.0/',
                requestHeaders: { Authorization: 'OAuth ' + sessionId},
                appendMessageTypeToURL : false
            });
            resourceFile.websocketEnabled = false;
            component.set('v.resourceFile', resourceFile);
            // Calling handshake() effectively sends a handshake message request to the server, 
            // and the Bayeux protocol requires that the server sends to the client a handshake message reply.
            // Once handshake() has been called, you must not call handshake() again 
            // unless you have explicitly disconnected by calling disconnect().
            resourceFile.handshake($A.getCallback(function(status) {
                if (status.successful) {
                    // Successfully connected to the server.
			        // Now it is possible to subscribe or send messages
					console.log('Successfully connected to server');
                    //use your channel name here
                    var eventName = component.get("v.channelName");
                    
                    //Subscribe to the event, which will call a callback function once the event 
                    //is being fired. Callback function will have the message received
                    var subscription = resourceFile.subscribe(eventName, $A.getCallback(function(message) {
                        console.log('New Event Received');
                    	//Fire the component event to notify parent component
                        var messageEvent = component.getEvent("onStreamEvent");
	                        if(messageEvent!=null) {
                                messageEvent.setParam("message", message.data);
                                messageEvent.fire();                            
	                        }
                        }
                    ));
                    
                    component.set('v.subscription', subscription);
                } else {
                    /// Cannot handshake with the server, alert user.
                    console.error('Error in handshaking: ' + status);
                }
            }));

        });
        $A.enqueueAction(action);
    },
    
    /**
     * This function will be fired once the component is destroyed
     * Used for unsubscribing the channel and disconnecting from the server
     * @author Manish Choudhari
     * @version 1.0.0
     * */
    unsubscribe : function (component, event, helper) {
        console.log('Inn Streaming');
        //get reference if cometD instance
		var resourceFile = component.get("v.resourceFile");
        //get current subscription
		var subscription = component.get("v.subscription");
        
        if(resourceFile){
            //Unsubscribing the current subscription
            resourceFile.unsubscribe(subscription, {}, function(unsubscribeReply) {
                if(unsubscribeReply.successful) {
                    //unsubcription is susccessful, disconnect from server now
                    console.log('Push topic successfully subscribed. Listening for events now');
                    resourceFile.disconnect(function(disconnectReply) 
                        { 
                            console.log('Push topic successfully unsubscribed.');
                            if(disconnectReply.successful) {
                                console.log('Successfully disconnected to server');
                            } else {
                                //Error in disconnect. Show user alert
                                console.error('Error is disconnecting')                    
                            }
                        });
                } else {
                     //Error in unsubscribe. Show user alert
                    console.error('Error in unsubscribe')                    		    
                }
            });
        }
    }
})