Coldbox Module to allow Social Login via Google
================

Setup & Installation
---------------------
In order to use Google OAuth, you must register for a Google Client Credientials. Visit https://console.developers.google.com/project and signup for the free account. Make sure to use to create an OAuth2 account. Server API keys & none oauth keys are not supported.

####Add the following structure to Coldbox.cfc
	google = {
		oauth = {
			redirectURL			= "{{what_is_the_internal_url}}",
			loginSuccess		= "login.success",
			loginFailure		= "login.failure",
			clientID			= "{{Google_Provided_ClientID}}",
			clientSecret		= "{{Google_Provided_ClientSecret}}",
			scope 				= "https://www.googleapis.com/auth/userinfo.email",
			accessType 			= "offline",
			approvalPrompt		= "auto",
			responseType		= "code"
		},
		analytics = {
			enabled 			= true,
			uaID 				= "{{Google_Analytics_uaID}}"
		}
	}

Interception Point
---------------------
If you want to capture any data from a successful login, use the interception point googleLoginSuccess. Inside the interceptData structure will contain all the provided data from google for the specific user.

####An example interception could look like this

	component {

		function googleLoginSuccess(event,interceptData){
			var queryService = new query(sql="SELECT roles,email,password FROM user WHERE googleUserID = :id;");
				queryService.addParam(name="id",value=interceptData['user_id']);
			var lookup = queryService.execute().getResult();

			if( lookup.recordCount ){
				login {
					loginuser name=lookup.email password=lookup.password roles=lookup.roles;
				};
			}else{
				// create new user
			}

		}
	}

