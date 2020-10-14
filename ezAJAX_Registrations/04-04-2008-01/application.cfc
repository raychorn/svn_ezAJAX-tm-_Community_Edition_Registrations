<cfcomponent>

	<cfscript>
		if (NOT IsDefined("This.name")) {
			aa = ListToArray(CGI.SCRIPT_NAME, '/');
			subName = aa[1];
			if (Len(subName) gt 0) {
				subName = '_' & subName;
			}

			myAppName = right(reReplace(CGI.SERVER_NAME & subName, "[^a-zA-Z]","_","all"), 64);
			myAppName = ArrayToList(ListToArray(myAppName, '_'), '_');
			This.name = UCASE(myAppName);
		}
	</cfscript>
	<cfset This.clientManagement = "Yes">
	<cfset This.sessionManagement = "Yes">
	<cfset This.sessionTimeout = CreateTimeSpan(0,1,0,0)>
	<cfset This.applicationTimeout = CreateTimeSpan(1,0,0,0)>
	<cfset This.clientStorage = "clientvars">
	<cfset This.loginStorage = "session">
	<cfset This.setClientCookies = "No">
	<cfset This.setDomainCookies = "No">
	<cfset This.scriptProtect = "All">

	<cffunction name="errorPage" output="No">
		<cfinclude template="error.cfm">
	</cffunction>

	<cfscript>
		function onError(Exception, EventName) {
			var errorExplanation = '';

			if ( (Len(Trim(EventName)) gt 0) AND (Len(Trim(errorExplanation)) gt 0) ) {
				this.cf_log('[#EventName#] [#errorExplanation#]');
			}

			if (NOT ( (EventName IS "onSessionEnd") OR (EventName IS "onApplicationEnd") ) ) {
				if (isDebugMode()) {
					writeOutput('<table width="100%" cellpadding="-1" cellspacing="-1">');
					writeOutput('<tr>');
					writeOutput('<td>');
					writeOutput(cf_dump(Application, 'Application Scope', false));
					writeOutput('</td>');
					writeOutput('<td>');
					writeOutput(cf_dump(Session, 'Session Scope', false));
					writeOutput('</td>');
					writeOutput('<td>');
					writeOutput(cf_dump(CGI, 'CGI Scope', false));
					writeOutput('</td>');
					writeOutput('<td>');
					writeOutput(cf_dump(URL, 'URL Scope', false));
					writeOutput('</td>');
					writeOutput('<td>');
					writeOutput(cf_dump(FORM, 'FORM Scope', false));
					writeOutput('</td>');
					writeOutput('<td>');
					writeOutput(cf_dump(Exception, 'CF Error: (' & EventName & ')', false));
					writeOutput('</td>');
					writeOutput('</tr>');
					writeOutput('</table>');
				} else {
					Request.Exception = Exception;
					errorPage();
				}
			}
		}
	</cfscript>

	<cffunction name="onSessionStart">
		<cfset Session.started = now()>
		<cfset Application.sessions = Application.sessions + 1>
		<cflog file="#Application.applicationName#" type="Information" text="Session #Session.sessionid# started. Active sessions: #Application.sessions#">
	</cffunction>

	<cffunction name="onSessionEnd">
		<cfargument name = "SessionScope" required=true/>
		<cfargument name = "AppScope" required=true/>
	
		<cfset var sessionLength = TimeFormat(Now() - SessionScope.started, "H:mm:ss")>
		<cfif (NOT IsDefined("Arguments.AppScope.sessions"))>
			<cfset ApplicationScope.sessions = 0>
		</cfif>
		<cfset Arguments.AppScope.sessions = Arguments.AppScope.sessions - 1>

		<cflog file="#Arguments.AppScope.applicationName#" type="Information" text="Session #Arguments.SessionScope.sessionid# ended. Length: #sessionLength# Active sessions: #Arguments.AppScope.sessions#">
	</cffunction>

	<cffunction name="onApplicationStart" access="public">
		<cflog file="#This.Name#" type="Information" text="Application Started">
		<!--- You do not have to lock code in the onApplicationStart method that sets
		      Application scope variables. --->
		<cfscript>
			Application.sessions = 0;
		</cfscript>
		<cfreturn True>
	</cffunction>

	<cffunction name="onApplicationEnd" access="public">
		<cfargument name="ApplicationScope" required=true/>
		<cflog file="#This.Name#" type="Information" text="Application #Arguments.ApplicationScope.applicationname# Ended" >
	</cffunction>

	<cffunction name="onRequestStart" access="public">
		<cfargument name = "_targetPage" required=true/>

		<cfinclude template="cfinclude_onRequest.cfm">
		<cfreturn True>
	</cffunction>

	<cffunction name="onRequestEnd" access="public">
		<cfargument name = "_targetPage" required=true/>

		<cfset var _sqlStatement = -1>

	</cffunction>
</cfcomponent>
