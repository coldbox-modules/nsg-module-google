component {

	property name="cacheStorage" 	inject="cacheStorage@cbstorages";
	
	function preHandler(event,rc,prc){
		prc.googleCredentials = getModuleSettings('nsg-module-google').OAuth;
		prc.googleSettings = getModuleSettings('nsg-module-google')['oauth'];
		if( !cacheStorage.exists( 'googleOAuth' ) ){
			cacheStorage.setVar( 'googleOAuth', structNew() );
		}
	}

	function index(event,rc,prc){
		if( event.getValue('id','') == 'activateUser' ){
			var results = duplicate( cacheStorage.getVar( 'googleOAuth' ) );
			var httpService = new http();
				httpService.setURL('https://www.googleapis.com/oauth2/v1/userinfo');
				httpService.addParam(type="url", name='access_token', value=results['access_token']);
			var data = deserializeJSON(httpService.send().getPrefix()['fileContent']);
			structAppend(results,data);

			structKeyRename(results,'id','referenceID');
			structKeyRename(results,'given_name','first');
			structKeyRename(results,'family_name','last');

			results['socialservice'] = 'google';

			announceInterception( state='googleLoginSuccess', interceptData=results );
			announceInterception( state='loginSuccess', interceptData=results );
			setNextEvent(view=prc.googleCredentials['loginSuccess'],ssl=( cgi.server_port == 443 ? true : false ));

		}else if( event.valueExists('code') ){
			results['code'] = event.getValue('code');

			var httpService = new http();
				httpService.setMethod('post');
				httpService.setURL(prc.googleSettings['tokenRequestURL']);
				httpService.addParam(type="formfield",name='code', value=results['code']);
				httpService.addParam(type="formfield",name='client_id', value=prc.googleCredentials['clientID']);
				httpService.addParam(type="formfield",name='client_secret', value=prc.googleCredentials['clientSecret']);
				httpService.addParam(type="formfield",name='redirect_uri', value=prc.googleCredentials['redirectURL']);
				httpService.addParam(type="formfield",name='grant_type', value='authorization_code');
			var results = httpService.send().getPrefix();

			if( results['status_code'] == 200 ){
				var json = deserializeJSON(results['fileContent']);

				for(var key IN json){
					results[key] = json[key];
				}
				cacheStorage.setVar( 'googleOAuth', results );
				setNextEvent('google/oauth/activateUser');
			}else{
				announceInterception( state='googleLoginFailure', interceptData=results );
				announceInterception( state='loginFailure', interceptData=results );
				throw('Unknown google OAuth.v2 Error','google.oauth');
			}

		}else{

			location(url="#prc.googleSettings['authorizeRequestURL']#?client_id=#prc.googleCredentials['clientID']#&redirect_uri=#urlEncodedFormat(prc.googleCredentials['redirectURL'])#&scope=#prc.googleCredentials['scope']#&response_type=#prc.googleCredentials['responseType']#&approval_prompt=#prc.googleCredentials['approvalPrompt']#&access_type=#prc.googleCredentials['accessType']#",addtoken=false);
		}
	}

	function structKeyRename(mStruct,mTarget,mKey){
		arguments.mStruct[mKey] = arguments.mStruct[mTarget];
		structDelete(arguments.mStruct,mTarget);

		return arguments.mStruct;
	}
}
