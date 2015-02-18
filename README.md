Coldbox Module to allow Social Login via Google
================

Setup & Installation
---------------------

####Add the following structure to Coldbox.cfc
	google = {
		oauth = {
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

