({
	doInit_Helper : function(c, e, h) {
		var url = window.location.href;
        var ret = url.split("?uId");
        console.log('ret----'+ret);
        if((ret[1] != undefined) && (ret[1] != '') && (ret[1] != ' '))
        {
            var getId = ret[1];
            var ss = getId.length;
            if(ss==15 || ss == 18)
            {
                h.UserGetId_Helper(c, e, h, getId);
            }
            else
            {
                $('#ForUser_SetPassword').hide();
                $('#ForUser_Login').hide();
                $('#ErrorUser').show();
            }
        }
        else
        {
            $('#ForUser_SetPassword').hide();
            $('#ForUser_Login').hide();
            $('#ErrorUser').show();
        }
	},
    UserGetId_Helper :function (c, e, h, getId){
        console.log('getId-->'+getId);
        c.set("v.userId", getId);
        var action = c.get("c.GetUserIdAndCheckForNewUserOrNot");
	    action.setParams({
            "UserId" : getId
        });
        action.setCallback( this, function(response){
            console.log('>>>>>>'+response.getState());
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
            	if(response==null)
            	{
                	Console.log('Null From Class');
            	}
                else
                {
                    console.log('----->>>'+JSON.stringify(respon));
                    var respCheck = JSON.stringify(respon);
                    if(respCheck === 'null')
                    {
                       console.log('Wrong User Id From URL');
                        $('#ForUser_SetPassword').hide();
                        $('#ForUser_Login').hide();
                        $('#ErrorUser').show();
                    }
                    else
                    {
                        if(((respon[0].Email__c == undefined) || (respon[0].Email__c == '') || (respon[0].Email__c == '')) && ((respon[0].Password__c == undefined) || (respon[0].Password__c == '') || (respon[0].Password__c == '')))
                        {
                            $('#ForUser_SetPassword').show();
                            $('#ForUser_Login').hide();
                            $('#ErrorUser').hide();
                            h.getAttachment_Helper(c, e, h, getId);
                        }
                        else
                        {
                            $('#ForUser_SetPassword').hide();
                            $('#ForUser_Login').show();
                            $('#ErrorUser').hide();
                            h.getAttachment_Helper(c, e, h, getId);
                        }
                    }
                }
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);
    },
    getAttachment_Helper : function(c, e, h, getId){
        console.log('000000getId'+getId);
        var action = c.get("c.GetAttachmentOfUserLogin");
	    action.setParams({
            "UserParentId" : getId
        });
        action.setCallback( this, function(response){
            if (response.getState() === "SUCCESS") {
            	var respon = response.getReturnValue();
                console.log('respon------>'+respon);
            	if(respon==null)
            	{
                	console.log('Null From The CLass Blank Image will be display');
                    // Not get Attachment
                    //-- http://www.mvc.gov.my/ph_album/mvc_council/no-profile-photo.jpg
                    c.set("v.viewImage", true);
                    
            	}
                else
                {
                   console.log('Success');
                	for(var i=0; i<respon.length; i++)
                    {
                        if(respon[0].Id != undefined)
                        {
                            var uu = respon[0].Id;
                            console.log('uuuuuuu'+uu);
                            var urlnew = 'https://retailshop-dev-ed--c.ap5.content.force.com/servlet/servlet.FileDownload?file='+uu;
                            console.log('---'+urlnew);
                            c.set("v.profilePic",urlnew);
                        }
                    }
        		}
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);
    },
    CreateLogin_JS_Helper : function(c, e, h){
        console.log('=======');
       	var name = c.get("v.NewUser.Name");
        var pass = c.get("v.NewUser.Password");
        var confPass = c.get("v.NewUser.ConfirmPassword");
        console.log('--->'+name);
        console.log('--->'+pass);
        console.log('--->'+confPass);
        if((name == undefined) || (name == '') || (name == ' '))
        {
            c.find('NewUserEmail').set("v.errors",[{message:"Email cannot be blank."}]);
        }
        else
        {
            c.find('NewUserEmail').set("v.errors",[{message:""}]);
            if((pass == undefined) || (pass == '') || (pass == ' '))
            {
                c.find('NewUserPassword').set("v.errors",[{message:"Password cannot be blank."}]);
            }
            else{
                c.find('NewUserPassword').set("v.errors",[{message:""}]);
                if((confPass == undefined) || (confPass == '') || (confPass == ' '))
                {
                    c.find('NewUserConfirmPassword').set("v.errors",[{message:"Confirm Password cannot be blank."}]);
                }
                else
                {
                    c.find('NewUserConfirmPassword').set("v.errors",[{message:""}]);
                    if(pass != confPass)
                    {
                        c.find('NewUserConfirmPassword').set("v.errors",[{message:"Password & Confirm Password don't Match."}]);
                    }
                    else
                    {
                        h.FirstTimeUserInsertEmail(c, e, h, name, pass);
                    }
                }
            }
        }
    },
    FirstTimeUserInsertEmail : function(c, e, h, name, pass)
    {
        console.log('----.>>.'); 
        var getId = c.get("v.userId");
        console.log('-->'+getId);
        console.log('name---'+name);
        
        var action = c.get("c.FirstTimeUserInsertEmail_Apex");
	    action.setParams({
            "userId" : getId,
            "userEmail" : name,
            "userPassword" : pass
        });
        action.setCallback( this, function(response)
		{
            if (response.getState() === "SUCCESS") 
            {
            	var respon = response.getReturnValue();
                console.log('respon------>'+respon);
            	if(respon==null)
            	{
                	console.log('Null From The CLass Blank Image will be display');
            	}
                else
                {
                   console.log('Success');
                    location.reload();
                    console.log('Updated Successfully Email and Password');
                }
            }
            else
            {
            	console.log('Response Error:');
            }
        });
	    $A.enqueueAction(action);
    },
})