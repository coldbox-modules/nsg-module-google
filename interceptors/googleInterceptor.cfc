component name="googleInterceptor" {

	public void function preProcess(event,interceptData) {
		var googleSetting = getSetting( name="google", fwSetting=false, defaultValue={} );

		if( structKeyExists(googleSetting,'analytics') &&
			structKeyExists(googleSetting['analytics'],'enabled') &&
			googleSetting['analytics']['enabled'] ){

			announceInterception( state='addPageBeforeEnd',
				interceptData={'html':renderView(view="includes/googleTracking",module="nsg-module-google")});
		}
	}

}