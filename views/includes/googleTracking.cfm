<cfset googleSetting = getSetting('google')>
<cfoutput>
<cfif structKeyExists(googleSetting,'analytics') &&
   	  structKeyExists(googleSetting['analytics'],'enabled') &&
	  googleSetting['analytics']['enabled'] &&
      structKeyExists(googleSetting['analytics'],'uaID')>
	<script>
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		ga('create', '#googleSetting['analytics']['uaID']#', 'auto');
		ga('send', 'pageview');

		<cfif isUserLoggedIn()>
			ga('set', '&uid', #getAuthUser()#);
		</cfif>
	</script>
</cfif>
</cfoutput>