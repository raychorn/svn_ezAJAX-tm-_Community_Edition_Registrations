<cfprocessingdirective pageencoding="utf-8">

<cfsavecontent variable="mail">
<cfoutput>
</cfoutput>
</cfsavecontent>

<cfmail to="raychorn@hotmail.com" from="sales@ez-ajax.com" subject="Error Report" type="#Request.typeOf_emailsContent#">#mail#</cfmail>

<cfsavecontent variable="_htmlPageContent">
<cfoutput>
<cfset todayDate = #Now()#>
<div class="date">#DateFormat(todayDate, "mm/dd/yyyy")# #TimeFormat(todayDate, "hh:mm:ss")#</div>
<div class="body">
<p>
</p>
	<cfset _mainURL = 'http://#CGI.SERVER_NAME#'>
	<a href="#_mainURL#">Click HERE to continue...</a>
</div>
</cfoutput>
</cfsavecontent>

<cfoutput>
#_htmlPageContent#
</cfoutput>
