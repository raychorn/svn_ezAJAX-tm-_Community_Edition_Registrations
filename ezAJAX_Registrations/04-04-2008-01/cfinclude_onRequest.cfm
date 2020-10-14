<cfinclude template="includes\cfinclude_explainError.cfm">

<cfscript>
	err_commonCode = -1;
	err_commonCodeMsg = -1;
</cfscript>

<cfscript>
	Request.bool_isDebugUser = false;

	Request.bool_isDebugMode = false;
	
	function filterQuotesForSQL(s) {
		return ReplaceNoCase(s, "'", "''", 'all');
	}
		
</cfscript>

<cfscript>
	Request.typeOf_emailsContent = 'HTML';
</cfscript>

<cffunction name="cf_wddx_WDDX2CFML" access="public" returntype="any">
	<cfargument name="_wddxPacket" type="string" required="yes">

	<cfwddx action="WDDX2CFML" input="#_wddxPacket#" output="_datum">
	
	<cfreturn _datum>
</cffunction>

<cffunction name="cf_wddx_CFML2WDDX" access="public" returntype="string">
	<cfargument name="_input_item_" type="any" required="yes">

	<cfset var _wddxPacket = -1>
	<cfwddx action="CFML2WDDX" input="#_input_item_#" output="_wddxPacket" usetimezoneinfo="Yes">
	
	<cfreturn _wddxPacket>
</cffunction>

<cffunction name="foldBlowFishStream" access="private" returntype="string">
	<cfargument name="inStr" required="Yes" type="string">
	<cfscript>
		var bc = Len(inStr);
		var bc2 = bc / 2;
		return Right(inStr, bc2) & Left(inStr, bc2);
	</cfscript>
</cffunction>

<cffunction name="_asBlowfishEncryptedHex" access="private" returntype="string">
	<cfargument name="inStr" required="Yes" type="string">
	<cfscript>
		var aKey = GenerateSecretKey('BLOWFISH');
		var inStrEnc = Encrypt(inStr, aKey, 'BLOWFISH', 'Hex');
		var aKeyEnc = BinaryEncode(ToBinary(toBase64(aKey)), 'Hex');
		var aKeyLen = Len(aKeyEnc);
		var aKeyLenEnc = BinaryEncode(ToBinary(toBase64(Chr(aKeyLen))), 'Hex');
		var strPadding = 4 - Len(aKeyLenEnc);
		var strEncDataStream = '';
		if (Len(inStr) lte 65535) {
			if (strPadding gt 0) {
				strEncDataStream = strEncDataStream & RepeatString('0', strPadding);
			}
			strEncDataStream = strEncDataStream & aKeyLenEnc;
			strEncDataStream = strEncDataStream & aKeyEnc;
			strEncDataStream = strEncDataStream & inStrEnc;
		}
		return strEncDataStream;
	</cfscript>
</cffunction>

<cffunction name="asBlowfishEncryptedHex" access="private" returntype="string">
	<cfargument name="inStr" required="Yes" type="string">
	<cfscript>
		var strEncDataStream = _asBlowfishEncryptedHex(inStr);
		if (isFoldable(strEncDataStream)) {
			return foldBlowFishStream(strEncDataStream);
		} else {
			return strEncDataStream;
		}
	</cfscript>
</cffunction>

<cffunction name="cf_file_write" access="public" returntype="any">
	<cfargument name="_fName_" type="string" required="yes">
	<cfargument name="_out_" type="string" required="yes">

	<cfset Request.errorMsg = "">	
	<cfset Request.fileError = false>	
	<cftry>
		<cffile action="WRITE" file="#_fName_#" output="#_out_#" attributes="Normal" addnewline="No" fixnewline="No">

		<cfcatch type="Any">
			<cfset Request.fileError = true>	

			<cfsavecontent variable="Request.errorMsg">
				<cfoutput>
					<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
					<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
				</cfoutput>
			</cfsavecontent>
		</cfcatch>
	</cftry>

</cffunction>

<cffunction name="safely_execSQL" access="public">
	<cfargument name="_qName_" type="string" required="yes">
	<cfargument name="_DSN_" type="string" required="yes">
	<cfargument name="_sql_" type="string" required="yes">
	<cfargument name="_cachedWithin_" type="string" default="">
	
	<cfset Request.errorMsg = "">
	<cfset Request.moreErrorMsg = "">
	<cfset Request.explainError = "">
	<cfset Request.explainErrorText = "">
	<cfset Request.explainErrorHTML = "">
	<cfset Request.dbError = "False">
	<cfset Request.isPKviolation = "False">
	<cftry>
		<cfif (Len(Trim(arguments._qName_)) gt 0)>
			<cfif (Len(_DSN_) gt 0)>
				<cfif (Len(_cachedWithin_) gt 0) AND (IsNumeric(_cachedWithin_))>
					<cfquery name="#_qName_#" datasource="#_DSN_#" cachedwithin="#_cachedWithin_#">
						#PreserveSingleQuotes(_sql_)#
					</cfquery>
				<cfelse>
					<cfquery name="#_qName_#" datasource="#_DSN_#">
						#PreserveSingleQuotes(_sql_)#
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery name="#_qName_#" dbtype="query">
					#PreserveSingleQuotes(_sql_)#
				</cfquery>
			</cfif>
		<cfelse>
			<cfset Request.errorMsg = "Missing Query Name which is supposed to be the first parameter.">
			<cfthrow message="#Request.errorMsg#" type="missingQueryName" errorcode="-100">
		</cfif>

		<cfcatch type="Any">
			<cfset Request.dbError = "True">

			<cfsavecontent variable="Request.errorMsg">
				<cfoutput>
					<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
					<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					<cfif (IsDefined("cfcatch.SQLState"))>[<b>cfcatch.SQLState</b>=#cfcatch.SQLState#]</cfif>
				</cfoutput>
			</cfsavecontent>

			<cfsavecontent variable="Request.moreErrorMsg">
				<cfoutput>
					<UL>
						<cfif (IsDefined("cfcatch.Sql"))><LI>#cfcatch.Sql#</LI></cfif>
						<cfif (IsDefined("cfcatch.type"))><LI>#cfcatch.type#</LI></cfif>
						<cfif (IsDefined("cfcatch.message"))><LI>#cfcatch.message#</LI></cfif>
						<cfif (IsDefined("cfcatch.detail"))><LI>#cfcatch.detail#</LI></cfif>
						<cfif (IsDefined("cfcatch.SQLState"))><LI>#cfcatch.SQLState#</LI></cfif>
					</UL>
				</cfoutput>
			</cfsavecontent>

			<cfsavecontent variable="Request.explainErrorText">
				<cfoutput>
					[#explainError(cfcatch, false)#]
				</cfoutput>
			</cfsavecontent>

			<cfsavecontent variable="Request.explainErrorHTML">
				<cfoutput>
					[#explainError(cfcatch, true)#]
				</cfoutput>
			</cfsavecontent>

			<cfscript>
				if (Len(_DSN_) gt 0) {
					Request.isPKviolation = _isPKviolation(Request.errorMsg);
				}
			</cfscript>

			<cfset Request.dbErrorMsg = Request.errorMsg>
			<cfsavecontent variable="Request.fullErrorMsg">
				<cfoutput>
					#Request.moreErrorMsg#
				</cfoutput>
			</cfsavecontent>
			<cfsavecontent variable="Request.verboseErrorMsg">
				<cfif (IsDefined("Request.bool_show_verbose_SQL_errors"))>
					<cfif (Request.bool_show_verbose_SQL_errors)>
						<cfoutput>
							#Request.explainErrorHTML#
						</cfoutput>
					</cfif>
				</cfif>
			</cfsavecontent>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="safely_cfmail" access="public" returntype="any">
	<cfargument name="_toAddrs_" type="string" required="yes">
	<cfargument name="_fromAddrs_" type="string" required="yes">
	<cfargument name="_theSubj_" type="string" required="yes">
	<cfargument name="_theBody_" type="string" required="yes">

	<cfset Request.anError = "False">
	<cfset Request.errorMsg = "">
	<cftry>
		<cfmail to="#_toAddrs_#" from="#_fromAddrs_#" subject="#_theSubj_#" type="HTML">#_theBody_#</cfmail>

		<cfcatch type="Any">
			<cfset Request.anError = "True">

			<cfsavecontent variable="Request.errorMsg">
				<cfoutput>
					#cfcatch.message#<br>
					#cfcatch.detail#
				</cfoutput>
			</cfsavecontent>
		</cfcatch>
	</cftry>

</cffunction>

<cfscript>
	const_PK_violation_msg = 'Violation of PRIMARY KEY constraint';

	function _isPKviolation(eMsg) {
		var bool = false;
		if (FindNoCase(const_PK_violation_msg, eMsg) gt 0) {
			bool = true;
		}
		return bool;
	}
</cfscript>
	
<cffunction name="cf_dump" access="public">
	<cfargument name="_aVar_" type="any" required="yes">
	<cfargument name="_aLabel_" type="string" required="yes">
	<cfargument name="_aBool_" type="boolean" required="No" default="False">
	
	<cfif (_aBool_)>
		<cfdump var="#_aVar_#" label="#_aLabel_#" expand="Yes">
	<cfelse>
		<cfdump var="#_aVar_#" label="#_aLabel_#" expand="No">
	</cfif>
</cffunction>

<cffunction name="cfdump" access="public" returntype="string">
	<cfargument name="_aVar_" type="any" required="yes">
	<cfargument name="_aLabel_" type="string" required="yes">
	<cfargument name="_aBool_" type="boolean" default="False">

	<cfsavecontent variable="_html">
		<cfoutput>
			<cfscript>
				if (IsDefined("_aBool_")) {
					cf_dump(_aVar_, _aLabel_, _aBool_);
				} else {
					cf_dump(_aVar_, _aLabel_);
				}
			</cfscript>
		</cfoutput>
	</cfsavecontent>
	
	<cfreturn _html>
</cffunction>

<cffunction name="isFoldable" access="private" returntype="string">
	<cfargument name="inStr" required="Yes" type="string">
	<cfscript>
		return ((Len(inStr) MOD 2) eq 0);
	</cfscript>
</cffunction>
