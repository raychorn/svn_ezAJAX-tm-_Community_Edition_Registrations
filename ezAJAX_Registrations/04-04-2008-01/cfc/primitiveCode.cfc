<cfcomponent displayname="primitiveCode" output="No">
	<cfinclude template="../includes/cfinclude_cflog.cfm">
	<cfinclude template="../includes/cfinclude_cfdump.cfm">
	
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

	<cffunction name="cfm_nocache" access="public">
		<CFSETTING ENABLECFOUTPUTONLY="YES">
		<cfoutput>
			<CFHEADER NAME="Expires" VALUE="Mon, 06 Jan 1990 00:00:01 GMT">
			<CFHEADER NAME="Pragma" VALUE="no-cache">
			<CFHEADER NAME="cache-control" VALUE="no-cache">
		</cfoutput>
		<CFSETTING ENABLECFOUTPUTONLY="NO">
	</cffunction>

	<cffunction name="cf_location" access="public" returntype="any">
		<cfargument name="_url_" type="string" required="yes">
	
		<cflocation url="#_url_#" addtoken="No">
	
	</cffunction>

	<cffunction name="cf_abort" access="public">
		<cfargument name="_errorMsg_" type="string" default="">
	
		<cfabort showerror="#_errorMsg_#">
	
	</cffunction>

	<cffunction name="cf_execute" access="public" returntype="any">
		<cfargument name="_name_" type="string" required="yes">
		<cfargument name="_args_" type="string" required="yes">
		<cfargument name="_timeout_" type="numeric" required="yes">
	
		<cfset Request.errorMsg = "">	
		<cfset Request.execError = false>	
		<cftry>
			<cfexecute name="#_name_#" arguments="#_args_#" variable="Request.cfexecuteOutput" timeout="#_timeout_#" />

			<cfcatch type="Any">
				<cfset Request.execError = true>	

				<cfsavecontent variable="Request.errorMsg">
					<cfoutput>
						<cfif (IsDefined("cfcatch.message"))>[#cfcatch.message#]<br></cfif>
						<cfif (IsDefined("cfcatch.detail"))>[#cfcatch.detail#]<br></cfif>
					</cfoutput>
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
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

	<cffunction name="cf_file_read" access="public" returntype="any">
		<cfargument name="_fName_" type="string" required="yes">
		<cfargument name="_vName_" type="string" required="yes">

		<cfset Request.errorMsg = "">	
		<cfset Request.fileError = false>	
		<cftry>
			<cffile action="READ" file="#_fName_#" variable="#_vName_#">

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

	<cffunction name="cf_file_read_binary" access="public" returntype="any">
		<cfargument name="_fName_" type="string" required="yes">
		<cfargument name="_vName_" type="string" required="yes">

		<cfset Request.errorMsg = "">	
		<cfset Request.fileError = false>	
		<cftry>
			<cffile action="READBINARY" file="#_fName_#" variable="#_vName_#">

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

	<cffunction name="cf_file_delete" access="public" returntype="any">
		<cfargument name="_fName_" type="string" required="yes">

		<cfset Request.errorMsg = "">	
		<cfset Request.fileError = false>	
		<cftry>
			<cffile action="DELETE" file="#_fName_#">

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

	<cffunction name="_safely_execSQL" access="public">
		<cfargument name="_qName_" type="string" required="yes">
		<cfargument name="_DSN_" type="string" required="yes">
		<cfargument name="_sql_" type="string" required="yes">
		<cfargument name="_cachedWithin_" type="string" default="">
		
		<cfscript>
			var q = -1;
		</cfscript>
	
		<cfset Request.errorMsg = "">
		<cfset Request.moreErrorMsg = "">
		<cfset Request.explainError = "">
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
	
			<cfcatch type="Database">
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
					<cfdump var="#cfcatch#" label="cfcatch">
				</cfsavecontent>
				<cfsavecontent variable="Request.verboseErrorMsg">
					<cfif (IsDefined("Request.bool_show_verbose_SQL_errors"))>
						<cfif (Request.bool_show_verbose_SQL_errors)>
							<cfdump var="#cfcatch#" label="cfcatch :: Request.isPKviolation = [#Request.isPKviolation#]" expand="No">
						</cfif>
					</cfif>
				</cfsavecontent>
	
				<cfscript>
					if ( (IsDefined("Request.bool_show_verbose_SQL_errors")) AND (IsDefined("Request.verboseErrorMsg")) ) {
						if (Request.bool_show_verbose_SQL_errors) {
							if (NOT Request.isPKviolation) 
								writeOutput(Request.verboseErrorMsg);
						}
					}
				</cfscript>
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

	<cffunction name="cf_http" access="public" returntype="any">
		<cfargument name="_url_" type="string" required="yes">
		<cfargument name="_resolveurl_" type="boolean" default="true">
		<cfargument name="_redirect_" type="boolean" default="false">

		<cfset Request.httpError = "False">
		<cfset Request.httpErrorMsg = "">
		<cfset Request.httpFullErrorMsg = "">
		<cftry>
			<cfif (_redirect_) AND (_resolveurl_)>
				<cfhttp url="#_url_#" method="GET" redirect="Yes" resolveurl="Yes">
			<cfelseif (_redirect_) AND (NOT _resolveurl_)>
				<cfhttp url="#_url_#" method="GET" redirect="Yes">
			<cfelseif (NOT _redirect_) AND (_resolveurl_)>
				<cfhttp url="#_url_#" method="GET" resolveurl="Yes">
			<cfelse>
				<cfhttp url="#_url_#" method="GET">
			</cfif>

			<cfcatch type="Any">
				<cfset Request.httpError = "True">

				<cfsavecontent variable="Request.httpErrorMsg">
					<cfoutput>
						#cfcatch.message#<br>
						#cfcatch.detail#
					</cfoutput>
				</cfsavecontent>
				<cfsavecontent variable="Request.httpFullErrorMsg">
					<cfdump var="#cfcatch#" label="cfcatch" expand="Yes">
				</cfsavecontent>
			</cfcatch>
		</cftry>
		
		<cfreturn cfhttp>
	</cffunction>

	<cffunction name="cf_directory" access="public" returntype="boolean">
		<cfargument name="_qName_" type="string" required="yes">
		<cfargument name="_path_" type="string" required="yes">
		<cfargument name="_filter_" type="string" required="yes">
		<cfargument name="_recurse_" type="boolean" default="False">
	
		<cfset Request.directoryError = "False">
		<cfset Request.directoryErrorMsg = "">
		<cfset Request.directoryFullErrorMsg = "">
		<cftry>
			<cfif (_recurse_)>
				<cfdirectory action="LIST" directory="#_path_#" name="#_qName_#" filter="#_filter_#" recurse="Yes">
			<cfelse>
				<cfdirectory action="LIST" directory="#_path_#" name="#_qName_#" filter="#_filter_#">
			</cfif>

			<cfcatch type="Any">
				<cfset Request.directoryError = "True">

				<cfsavecontent variable="Request.directoryErrorMsg">
					<cfoutput>
						#cfcatch.message#<br>
						#cfcatch.detail#
					</cfoutput>
				</cfsavecontent>
				<cfsavecontent variable="Request.directoryFullErrorMsg">
					<cfdump var="#cfcatch#" label="cfcatch" expand="Yes">
				</cfsavecontent>
			</cfcatch>
		</cftry>
	
		<cfreturn Request.directoryError>
	</cffunction>

	<cffunction name="rs2Query" output="false" hint="returns a query from a Java ResultSet object">
		<cfargument name="resultset" type="any" required="true">
		
		<cfset var rs = resultset>
		<cfset var x = false>
		<cfset var col = false>
		<cfset var colnames = "">
		<cfset var tableData = false>
		
		<cfif isobject(resultset) AND findnocase("resultset",resultset.getClass().getName())>
			<cfset tabledata = resultset.getMetaData()>
			<cfloop index="x" from="1" to="#tableData.getColumnCount()#">
				<cfset colnames = listappend(colnames,tableData.getColumnName(JavaCast("int",x)))>
			</cfloop>
			<cfset rs = querynew(colnames)>
			
			<cfloop condition="resultset.next()">
				<cfif resultset.getRow()>
					<cfset queryaddrow(rs)>
					<cfset x = rs.recordcount>
					<cfloop index="col" list="#colnames#">
						<cfset rs[col][x] = resultset.getString(JavaCast("string",col))>
					</cfloop>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn rs>
	</cffunction>
<!--- +++ --->
	<cffunction name="jdbcType" output="false" returntype="string" hint="returns the name or number for a given Java JDBC data type">
		<cfargument name="typeid" type="string" required="true">
		
		<cfset var sqltype = createobject("java","java.sql.Types")>
		<cfset var types = structnew()>
		
		<cfloop item="x" collection="#sqltype#">
			<cfset types[x] = sqltype[x]>
			<cfset types[sqltype[x]] = x>
		</cfloop>
		
		<cfreturn types[typeid]>
	</cffunction>

	<cffunction name="oJDBCMetaData" access="public" returntype="struct">
		<cfargument name="_dsn_" type="string" required="true">
		<cfargument name="_username_" type="string" required="true">
		<cfargument name="_password_" type="string" required="true">

		<cfscript>
			var aStruct = StructNew();
			var factory = -1;
		</cfscript>

		<cflock name="coldfusion.server.ServiceFactory" type="exclusive" timeout="10">
			<cfscript>
				factory = CreateObject("java", "coldfusion.server.ServiceFactory");
				aStruct.ds_service = factory.datasourceservice;
				aStruct.conn = aStruct.ds_service.getDataSource(_dsn_).getConnection(_username_,_password_);
				aStruct.mdata = aStruct.conn.getMetaData();
			</cfscript>			
		</cflock>
		
		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCCatalog" access="public" returntype="struct">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		
		<cfscript>
			var aStruct = StructNew();

			aStruct.rsCatalog = _oMetaData_.mdata.getCatalogs();
			aStruct.qCatalog = rs2Query(aStruct.rsCatalog);
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCSchema" access="public" returntype="struct">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		
		<cfscript>
			var aStruct = StructNew();

			aStruct.rsSchemas = _oMetaData_.mdata.getSchemas();
			aStruct.qSchemas = rs2Query(aStruct.rsSchemas);
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCTables" access="public" returntype="struct">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		<cfargument name="_schemaName_" type="string" required="true">
		
		<cfscript>
			var aStruct = StructNew();

			aStruct.rsTables = _oMetaData_.mdata.getTables(JavaCast("null",""), _schemaName_, JavaCast("null",""), JavaCast("null",""));
			aStruct.qTables = rs2Query(aStruct.rsTables);
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCTableTypes" access="public" returntype="struct">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		
		<cfscript>
			var aStruct = StructNew();

			aStruct.rsTableTypes =  _oMetaData_.mdata.getTableTypes();
			aStruct.qTableTypes = rs2Query(aStruct.rsTableTypes);
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cffunction name="qJDBCColumns" access="public" returntype="struct">
		<cfargument name="_oMetaData_" type="struct" required="yes">
		<cfargument name="_DbName_" type="string" required="true">
		<cfargument name="_tableName_" type="string" required="true">
		
		<cfscript>
			var aStruct = StructNew();
			var i = -1;

			aStruct.rsColumns = _oMetaData_.mdata.getColumns(_DbName_,"%",_tableName_,"%");
			aStruct.qColumns = rs2Query(aStruct.rsColumns);

			for (i = 1; i lte aStruct.qColumns.recordCount; i = i + 1) {
				aStruct.qColumns.data_type[i] = jdbcType(aStruct.qColumns.data_type[i]);
			}
		</cfscript>

		<cfreturn aStruct>
	</cffunction>

	<cffunction name="execViaSessionLock" access="public">
		<cfargument name="_aCFFunc_" type="any" required="yes">
		
		<cfif (IsCustomFunction(_aCFFunc_))>
			<cfset Request.cflockErrorMsg = "">
			<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
				<cftry>
					<cfscript>
						_aCFFunc_();
					</cfscript>
	
					<cfcatch type="Any">
						<cfsavecontent variable="Request.cflockErrorMsg">
							<cfoutput>
								_someCFcode_ = [#_someCFcode_#]<br>
								#cfcatch.message#<br>
								#cfcatch.detail#
							</cfoutput>
						</cfsavecontent>
					</cfcatch>
				</cftry>
			</cflock>
		<cfelse>
			<cfset Request.cflockErrorMsg = "ERROR: Invalid value for argument known as '_aCFFunc_' in function known as execViaSessionLock().">
		</cfif>
	</cffunction>

	<cffunction name="scopesDebugPanelContentLayout" access="public" returntype="string">
		<cfsavecontent variable="content_scopes_debug_panel">
			<cfoutput>
				<table width="100%" cellpadding="-1" cellspacing="-1">
					<tr>
						<td valign="top" align="left">
							<table width="100%" cellpadding="-1" cellspacing="-1">
								<tr>
									<td align="left" valign="top">
										<div id="div_application_debug_panel"></div>
									</td>
									<td align="left" valign="top">
										<div id="div_session_debug_panel"></div>
									</td>
									<td align="left" valign="top">
										<div id="div_cgiScope_debug_panel"></div>
									</td>
									<td align="left" valign="top">
										<div id="div_requestScope_debug_panel"></div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</cfoutput>
		</cfsavecontent>

		<cfreturn content_scopes_debug_panel>
	</cffunction>

	<cffunction name="decipher_func" access="public" returntype="string">
		<cfsavecontent variable="js_decipher_func">
			<cfoutput>
				function d$(enc, p){ 
					var teks=''; 
					var ar = enc[0]; 
					var p_i=0;
					for (var i=0;i<ar.length;i+=2){ 
						teks+=String.fromCharCode(ar.substr(i,2).fromHex()^p.charAt(p_i)); 
						p_i++; 
						if (p_i >= p.length) { 
							p_i = 0; 
						}; 
					}
					return teks.URLDecode();
				};
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn js_decipher_func>
	</cffunction>
	
	<cffunction name="registerNoticeMessage" access="public" returntype="string">
		<cfargument name="_username_" type="string" required="yes">
		<cfargument name="_uuid_" type="string" required="yes">
		
		<cfset var registerNotice = "">
		<cfset var instance = application.blog.instance>
		<cfset var _urlValidateLink = clusterizeURL('http://rabid.contentopia.net') & '/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/validateUserAccount/#_username_#/' & '?' & _uuid_>
		
		<cfsavecontent variable="registerNotice">
			<cfoutput>
				<cfmodule template="../tags/singleTabbedContent.cfm" tabTitle="Validation Email">
					<H3>This is your User Account Validation Email from #instance.blogTitle#</H3>
					
					<H5 style="color: blue;">You have 24 hrs to Validate your User Account.</H5>
					
					<p align="justify" style="font-size: 10px;"><small>
					<a href="#_urlValidateLink#" target="_blank">Click HERE</a> to validate your user account.
					</small>
					</p>
				</cfmodule>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn registerNotice>
	</cffunction>
	
	<cffunction name="cf_loginuser" access="public" returntype="string">
		<cfargument name="_username_" type="string" required="yes">
		<cfargument name="_password_" type="string" required="yes">
		
		<cfset var bool_isError = false>
		<cftry>
			<cflogin>
				<cfloginuser name="#trim(_username_)#" password="#trim(_password_)#" roles="admin">
			</cflogin>

			<cfcatch type="Any">
				<cfset bool_isError = true>
			</cfcatch>
		</cftry>		
		
		<cfreturn bool_isError>
	</cffunction>
	
	<cffunction name="cf_userlogout" access="public" returntype="string">
		
		<cfset var bool_isLoggedIn = false>
		<cftry>
			<cflogout>

			<cfcatch type="Any">
				<cfset bool_isLoggedIn = false>
			</cfcatch>
		</cftry>		
		
		<cfreturn bool_isLoggedIn>
	</cffunction>
	
	<cffunction name="performForgotPasswordAction" access="public" returntype="string">
		<cfargument name="_username_" type="string" required="yes">
		
		<cfset var _sqlStatement = "">
		<cfset var forgotPasswordEmail = "">
		<cfset var instance = application.blog.instance>
		
		<cfif (Len(_username_) gt 0)>
			<cfscript>
				_sqlStatement = "SELECT password FROM tblUsers WHERE (username = '#Request.commonCode.filterQuotesForSQL(_username_)#')";
				safely_execSQL('Request.qGetBlogUserPassword', instance.dsn, _sqlStatement);
				if (Request.dbError) {
					cf_log(Application.applicationname, 'Error', '[#Request.explainErrorText#]');
				}
			</cfscript>
		
			<cfsavecontent variable="forgotPasswordEmail">
				<cfoutput>
				<cfif 0>
					<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
					
					<html>
					<head>
						<title>© Hierarchical Applications Limited, All Rights Reserved.</title>
					</head>
					
					<body>
					
					<cftry>
						<cfsavecontent variable="yourPassword_html">
							<cfoutput>
								<cfif (IsDefined("Request.qGetBlogUserPassword.password"))>"<b>#decodeEncodedEncryptedString(Request.qGetBlogUserPassword.password).PLAINTEXT#</b>"</cfif>
							</cfoutput>
						</cfsavecontent>
					
						<cfcatch type="Any">
							<cfset yourPassword_html = "">
						</cfcatch>
					</cftry>
					<small style="color: blue;">Your password is <b>#yourPassword_html#</b>.<br>(The password in <b>bold</b> appears between the '"' characters.)</small>
					
					<small>Your password remains secure because we only share this information with you upon request.</small>
					
					</body>
					</html>
				<cfelse>
					<cfmodule template="../tags/singleTabbedContent.cfm" tabTitle="Forgot Password">
						<cftry>
							<cfsavecontent variable="yourPassword_html">
								<cfoutput>
									<cfif (IsDefined("Request.qGetBlogUserPassword.password"))>"<b>#decodeEncodedEncryptedString(Request.qGetBlogUserPassword.password).PLAINTEXT#</b>"</cfif>
								</cfoutput>
							</cfsavecontent>
						
							<cfcatch type="Any">
								<cfset yourPassword_html = "">
							</cfcatch>
						</cftry>
						<small style="color: blue;">Your password is <b>#yourPassword_html#</b>.<br>(The password in <b>bold</b> appears between the '"' characters.)</small>
						<br>
						<small>Your password remains secure because we only share this information with you upon request.</small>
					</cfmodule>
				</cfif>
				</cfoutput>
			</cfsavecontent>
		
			<cfscript>
				if (NOT Request.dbError) {
					safely_cfmail(_username_, 'do-not-respond@contentopia.net', 'User Password EMail from #instance.blogTitle#', forgotPasswordEmail);
				}
			</cfscript>
		</cfif>
		
		<cfreturn ( (NOT Request.dbError) AND (NOT Request.anError) )>
	</cffunction>
	
	<cffunction name="setupClusterDBDSN" access="private">
		<cfscript>
			Request.ClusterDB_DSN = 'ClusterDB';
			Request.isRunningOnCluster = true;
			if (isDebugMode() OR (_isServerLocal())) {
				Request.ClusterDB_DSN = '@ClusterDB'; // development only...
				Request.isRunningOnCluster = false;
			}
		</cfscript>
	</cffunction>

	<cffunction name="readSessionFromDb" access="public">
		<cfargument name="_sessid_" type="string" default="">
		<cfscript>
			var _urltoken = '';
			var _sessID = -1;
			var _wddxPacket = '';
			var _sqlStatement = '';
			var _referrer = '';
			var _serverName = '';

			setupClusterDBDSN();
			
			bool_IsDefined_ARGUMENT_sessID = false;
			bool_IsDefined_Session_sessID = false;
			bool_IsDefined_URL_sessID = false;
			bool_IsDefined_FORM_sessID = false;
			bool_IsDefined_Client_sessID = false;
			
			_referrer = getClusterizedDomainFromReferrer(CGI.HTTP_REFERER);
			_serverName = getClusterizedDomainFromReferrer(CGI.SERVER_NAME);
			
			_sessID = -1;
			if (Len(_sessid_) gt 0) {
				_sessID = _sessid_;
				bool_IsDefined_ARGUMENT_sessID = true;
			}
			if ( (UCASE(_referrer) eq UCASE(_serverName)) AND (NOT IsValid('UUID', _sessID)) ) { // this inhibits an outside usage of the session ID from being abused...
				if ( (IsDefined("URL.sessID")) AND (NOT IsValid('UUID', _sessID)) ) {
					_sessID = URL.sessID;
					bool_IsDefined_URL_sessID = true;
				} else {
					bool_IsDefined_URL_sessID = false;
					if ( (IsDefined("FORM.sessID")) AND (NOT IsValid('UUID', _sessID)) ) {
						_sessID = FORM.sessID;
						bool_IsDefined_FORM_sessID = true;
					} else {
						bool_IsDefined_FORM_sessID = false;
						if ( (IsDefined("Client.sessID")) AND (NOT IsValid('UUID', _sessID)) ) {
							_sessID = Client.sessID;
							bool_IsDefined_Client_sessID = true;
						} else {
							bool_IsDefined_Client_sessID = false;
							if ( (IsDefined("Session.sessID")) AND (NOT IsValid('UUID', _sessID)) ) {
								_sessID = Session.sessID;
								bool_IsDefined_Session_sessID = true;
							} else {
								bool_IsDefined_Session_sessID = false;
							}
						}
					}
				}
			}
		</cfscript>

		<cfscript>
			if ( ( (isDebugMode()) OR (isServerLocal()) ) AND (FindNoCase('/newDownloads.cfm', CGI.SCRIPT_NAME) eq 0) AND (FindNoCase('/newCalendar.cfm', CGI.SCRIPT_NAME) eq 0) AND (FindNoCase('/ezAJAXLogo.cfm', CGI.SCRIPT_NAME) eq 0) AND (FindNoCase('/AJAX_functions.cfm', CGI.SCRIPT_NAME) eq 0) AND (FindNoCase('/ezAJAX-Registrations/registerProduct.cfm', CGI.SCRIPT_NAME) eq 0) ) {
				_urlAJAXBlog = _sessID;
				if (FindNoCase('/AJAX-Framework/', CGI.SCRIPT_NAME) eq 0) {
					_urlAJAXBlog = clusterizeURL('http://#CGI.SERVER_NAME#/' & ListFirst(CGI.SCRIPT_NAME, '/') & '/AJAX-Framework/index.cfm') & '?sessID=#_sessID#';
					_urlAJAXBlog = '<a href="#_urlAJAXBlog#" target="_blank">#_sessID#</a>';
				}
				writeOutput('<small style="font-size: 9px; color: blue;"><b>(#_urlAJAXBlog#) (#_referrer#) (#_serverName#) (#CGI.SCRIPT_NAME#), ARGUMENT._sessid_ = [#bool_IsDefined_ARGUMENT_sessID#], URL.sessID = [#bool_IsDefined_URL_sessID#], FORM.sessID = [#bool_IsDefined_FORM_sessID#], Client.sessID = [#bool_IsDefined_Client_sessID#], Session.sessID = [#bool_IsDefined_Session_sessID#]</b></small><br>');
			}
		</cfscript>

		<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
			<cfscript>
				if (NOT IsDefined("Request.ClusterDB_DSN")) {
					setupClusterDBDSN();
				}

				_sqlStatement = "SELECT Applications.id as appID, Applications.AppName, Sessions.id, Sessions.sessionUUID AS sessID, Sessions.sessionDt, Sessions.lastAccessDt, Sessions._wddx FROM Applications INNER JOIN Sessions ON Applications.id = Sessions.appID WHERE (Sessions.sessionUUID = '#_sessID#')";
				safely_execSQL('Request.qCheckSession', Request.ClusterDB_DSN, _sqlStatement);
				if (NOT Request.dbError) {
					if (Request.qCheckSession.recordCount eq 0) {	// create the session record...
						Session.sessID = -1;
						
						_theAppName = Application.applicationname;
						if ( (IsDefined("_appName")) AND (Len(_appName) gt 0) ) {
							_theAppName = _appName;
						}
	
						_sqlStatement = "SELECT id FROM Applications WHERE (AppName = '#_theAppName#')";
						safely_execSQL('Request.qCheckApplication', Request.ClusterDB_DSN, _sqlStatement);
						if (NOT Request.dbError) {
							if (Request.qCheckApplication.recordCount eq 0) {
								_sqlStatement = "INSERT INTO Applications (AppName) VALUES ('#_theAppName#'); SELECT @@IDENTITY as 'id';";
								safely_execSQL('Request.qCheckApplication', Request.ClusterDB_DSN, _sqlStatement);
							}
	
							if (NOT Request.dbError) {
								if (Request.qCheckApplication.recordCount gt 0) {
									if (NOT IsDefined("Session.persistData")) {
										Session.persistData = StructNew();
									}
									_wddxPacket = cf_wddx_CFML2WDDX(Session.persistData);
									_sessionUUID = CreateUUID();
									_sqlStatement = "INSERT INTO Sessions (appID, sessionUUID, sessionDt, lastAccessDt, _wddx) VALUES (#Request.qCheckApplication.id#,'#_sessionUUID#',GetDate(),GetDate(),'#filterQuotesForSQL(_wddxPacket)#'); SELECT @@IDENTITY as 'id';";
									safely_execSQL('Request.qAddSession', Request.ClusterDB_DSN, _sqlStatement);
									if (NOT Request.dbError) {
										if (Request.qAddSession.recordCount gt 0) {
											Session.sessID = _sessionUUID;
											Client.sessID = Session.sessID;
											Session.sessionDt = CreateODBCDateTime(Now());
											if (NOT IsDefined("Session.persistData.loginFailure")) {
												Session.persistData.loginFailure = 0;
											}
											if (NOT IsDefined("Session.persistData.loggedin")) {
												Session.persistData.loggedin = false;
											}
											if (NOT IsDefined("Session.persistData.shoppingCart")) {
												Session.persistData.shoppingCart = StructNew();
											}
											if (NOT IsDefined("Session.persistData.shoppingCart.items")) {
												Session.persistData.shoppingCart.items = 0;
											}
											if (NOT IsDefined("Session.persistData.blogname")) {
												Session.persistData.blogname = 'Default';  // this allows the correct blogname to be known across all servers...
											}
										}
									} else {
										cf_log('[#Request.explainErrorText#] [#_sqlStatement#]');
									}
								}
							} else {
								cf_log('[#Request.explainErrorText#] [#_sqlStatement#]');
							}
						} else {
							cf_log('[#Request.explainErrorText#] [#_sqlStatement#]');
						}
					} else {										// read the session record...
						Session.persistData = cf_wddx_WDDX2CFML(Request.qCheckSession._wddx);
						Session.sessID = Request.qCheckSession.sessID;
						Client.sessID = Session.sessID;
						Session.sessionDt = Request.qCheckSession.sessionDt;
						if (NOT IsDefined("Session.persistData.loginFailure")) {
							Session.persistData.loginFailure = 0;
						}
						if (NOT IsDefined("Session.persistData.loggedin")) {
							Session.persistData.loggedin = false;
						}
						if (NOT IsDefined("Session.persistData.shoppingCart")) {
							Session.persistData.shoppingCart = StructNew();
						}
						if (NOT IsDefined("Session.persistData.shoppingCart.items")) {
							Session.persistData.shoppingCart.items = 0;
						}
						if (NOT IsDefined("Session.persistData.blogname")) {
							Session.persistData.blogname = 'Default';  // this allows the correct blogname to be known across all servers...
						}
					}
				} else {
					if ( (isDebugMode()) OR (isServerLocal()) ) {
						writeOutput('<small style="font-size: 10px; color: blue;">Request.dbError = [#Request.dbError#] [#Request.errorMsg#]</small><br>');
						writeOutput(cf_dump(Request, 'Request', false));
					}
					cf_log('[#Request.explainErrorText#] [#_sqlStatement#]');
				}
			</cfscript>
		</cflock>
	</cffunction>

	<cffunction name="retireSessions" access="public">
		
		<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
			<cfscript>
				if (NOT IsDefined("Request.ClusterDB_DSN")) {
					setupClusterDBDSN();
				}

				_sqlStatement = "SELECT sessionUUID as 'id' FROM Sessions WHERE (lastAccessDt IS NULL) OR (DATEDIFF(minute, lastAccessDt, GETDATE()) > 90)";
				safely_execSQL('Request.qGetRetirableSessions', Request.ClusterDB_DSN, _sqlStatement);
				if (Request.dbError) {
					cf_log('commitSessionToDb.2 :: [#Request.explainErrorText#] [#_sqlStatement#]');
				} else {
					ar_retireableSessions = ArrayNew(1);
					for (i = 1; i lte Request.qGetRetirableSessions.recordCount; i = i + 1) {
						ar_retireableSessions[ArrayLen(ar_retireableSessions) + 1] = Request.qGetRetirableSessions.id[i];
					}
				}
				_sqlStatement = "SELECT DISTINCT sessID as 'id' FROM tblUsersSession WHERE id NOT IN (SELECT DISTINCT tblUsersSession.id FROM tblUsersSession INNER JOIN ClusterDB.dbo.Sessions AS cs ON tblUsersSession.sessID = cs.sessionUUID)";
				safely_execSQL('Request.qGetRetirableSessions2', application.blog.instance.dsn, _sqlStatement);
				if (Request.dbError) {
					cf_log('commitSessionToDb.3 :: [#Request.explainErrorText#] [#_sqlStatement#]');
				} else {
					for (i = 1; i lte Request.qGetRetirableSessions2.recordCount; i = i + 1) {
						ar_retireableSessions[ArrayLen(ar_retireableSessions) + 1] = Request.qGetRetirableSessions2.id[i];
					}
				}

				cf_log('X. ArrayLen(ar_retireableSessions) = [#ArrayLen(ar_retireableSessions)#]');
					
				if (ArrayLen(ar_retireableSessions) gt 0) {
					_retireableSessions = ArrayToList(ar_retireableSessions, ',');

					cf_log('X.1 _retireableSessions = [#_retireableSessions#]');
					
					if (ListLen(_retireableSessions, ',') gt 0) {
						_sqlStatement = "DELETE FROM tblUsersSession WHERE (sessID in (#listToSQLList(_retireableSessions)#))";
						safely_execSQL('Request.qRetireUserSessions', application.blog.instance.dsn, _sqlStatement);
						if (Request.dbError) {
							cf_log('commitSessionToDb.4 :: [#Request.explainErrorText#] [#_sqlStatement#]');
						}
					}
					// What about Sessions that have already been retired ?
					_sqlStatement = "SELECT sessID FROM tblUsersSession";
					safely_execSQL('Request.qChkForRetiredUserSessions', application.blog.instance.dsn, _sqlStatement);
					if (Request.dbError) {
						cf_log('commitSessionToDb.5 :: [#Request.explainErrorText#] [#_sqlStatement#]');
					} else {
						arOfAllSessionIDs = ArrayNew(1);
						for (i = 1; i lte Request.qChkForRetiredUserSessions.recordCount; i = i + 1) {
							_sqlStatement = "SELECT id FROM Sessions WHERE (sessionUUID = '#Request.qChkForRetiredUserSessions.sessID[i]#')";
							safely_execSQL('Request.qGetRetirableSessions2a', Request.ClusterDB_DSN, _sqlStatement);
							if (Request.dbError) {
								cf_log('commitSessionToDb.6 :: [#Request.explainErrorText#] [#_sqlStatement#]');
							} else {
								if ( (IsQuery(Request.qGetRetirableSessions2a)) AND (Request.qGetRetirableSessions2a.recordCount eq 0) ) {
									arOfAllSessionIDs[ArrayLen(arOfAllSessionIDs) + 1] = Request.qChkForRetiredUserSessions.sessID[i];
								}
							}
						}
						listOfAllSessionIDs = ArrayToList(arOfAllSessionIDs, ',');

						if (ListLen(listOfAllSessionIDs, ',') gt 0) {
							_sqlStatement = "DELETE FROM tblUsersSession WHERE (sessID IN (#listToSQLList(listOfAllSessionIDs)#))";
							safely_execSQL('Request.qRetireDeadUserSessions', application.blog.instance.dsn, _sqlStatement);
							if (Request.dbError) {
								cf_log('commitSessionToDb.7 :: [#Request.explainErrorText#] [#_sqlStatement#]');
							}
						}
					}
				}

				_sqlStatement = "DELETE FROM Sessions WHERE (lastAccessDt IS NULL) OR (DATEDIFF(minute, lastAccessDt, GETDATE()) > 90)";
				safely_execSQL('Request.qRetireSessions', Request.ClusterDB_DSN, _sqlStatement);
				if (Request.dbError) {
					cf_log('commitSessionToDb.8 :: [#Request.explainErrorText#] [#_sqlStatement#]');
				}
			</cfscript>
		</cflock>

	</cffunction>

	<cffunction name="commitSessionToDb" access="public">
		
		<cflock timeout="10" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
			<cfscript>
				if (NOT IsDefined("Request.ClusterDB_DSN")) {
					setupClusterDBDSN();
				}

				if ( (IsDefined("Session.sessID")) AND (Session.sessID gt 0) ) {
					if (NOT IsDefined("Session.persistData")) {
						Session.persistData = StructNew();
					}

					try {
						if (StructKeyExists(Session.persistData, 'urltoken')) StructDelete(ptr, 'urltoken');
					} catch (Any e) {
					}

					_wddxPacket = cf_wddx_CFML2WDDX(Session.persistData);
					_sqlStatement = "UPDATE Sessions SET _wddx = '#filterQuotesForSQL(_wddxPacket)#', lastAccessDt = GetDate() WHERE (sessionUUID = '#Session.sessID#')";
					safely_execSQL('Request.qUpdateSession', Request.ClusterDB_DSN, _sqlStatement);
					if (Request.dbError) {
						cf_log('commitSessionToDb.1 :: [#Request.explainErrorText#] [#_sqlStatement#]');
					}
				}

				retireSessions();

				_isloggedin = 0;
				_uid = -1;
				try {
					if (session.persistData.loggedin) {
						_isloggedin = 1;
						_uid = Session.persistData.qauthuser.id;
					}
				} catch (Any e) {
				}
				_sqlStatement = "INSERT INTO tblUsersActivities (uid, sessID, isloggedin, today, script_name, http_referrer, query_string) VALUES (#_uid#, '#Session.sessID#', #_isloggedin#, GetDate(),'#filterQuotesForSQL(CGI.SCRIPT_NAME)#','#filterQuotesForSQL(CGI.HTTP_REFERER)#','#Left(filterQuotesForSQL(URLDecode(CGI.QUERY_STRING)), 512)#'); SELECT @@IDENTITY as 'id';";
				safely_execSQL('Request.qLogUsersActivities', application.blog.instance.dsn, _sqlStatement);
				if (Request.dbError) {
					cf_log('commitSessionToDb.9 :: [#Request.explainErrorText#] [#_sqlStatement#]');
				}
			</cfscript>
		</cflock>

	</cffunction>

</cfcomponent>

