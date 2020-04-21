({
	doInit_Helper : function(c, e, h) {
        
        var sess_Id = $.session.get('sessionId');
		if(sess_Id != undefined)
        {
            if(sess_Id.length == 18)
            {
                var logUser = c.get("c.loginUser_Apex");
                logUser.setParams({
                    "currentUserId" : sess_Id
                });
                logUser.setCallback( this, function(response){
                    if (response.getState() === "SUCCESS")
                    {
                        var resp = response.getReturnValue();
                        if(resp == null)
                        {
                            //c.set("v.loginStatus", false);
                            console.log('Null From the class');
                            c.set("v.loginStatus", true);
                        }
                        else
                        {
                            var conid = resp.Id;
                            var completeName=resp.Name;
                            c.set("v.completeName",completeName);
                            console.log('Name--->'+completeName);
                            c.set("v.loginStatus", true);
                            console.log('-------->'+c.get("v.loginStatus"));
                        }
                    }
                    else
                    {
                        
                        console.log('----- Response Error:');
                    }
                });
               $A.enqueueAction(logUser);
            }
            
            
            
/*          var login_page = c.get("c.login_Apex_Verifier");
            login_page.setCallback( this, function(response){
                if (response.getState() === "SUCCESS")
                {
                    if(response.getReturnValue() == null)
                    {
                        c.set("v.loginStatus", false);
                    }
                    else
                    {
                        c.set("v.loginStatus", true);
                    }
                }
                else
                {
                    
                    console.log('----- Response Error:');
                }
            });
           $A.enqueueAction(login_page);
*/
        }
	},
	confirmLoginJS_Helper : function(c, e, h){
		var userEmail = c.find("username").get("v.value");
		var userPassword = c.find("password").get("v.value");
		var login_page_confirm = c.get("c.login_Apex");
		console.log('--->usrname'+userEmail);
		console.log('--->userPassword'+userPassword);
		login_page_confirm.setParams({
            "Email" : userEmail,
            "Password" : userPassword
        });
        login_page_confirm.setCallback( this, function(response){
            if (response.getState() === "SUCCESS")
            {
                var resp = response.getReturnValue();
                if(resp == null)
                {
                	console.log('Null');
                    c.set("v.loginStatus", false);
                }
                else
                {
                	console.log('Done');
                    var conid = resp.Id;
                    var completeName=resp.Name;
                    c.set("v.completeName",completeName);
                    $.session.set('sessionId', conid);
                    c.set("v.loginStatus", true);
                }
            }
            else
            {
                console.log('Response Error:');
            }
        });
       $A.enqueueAction(login_page_confirm);
	},
})