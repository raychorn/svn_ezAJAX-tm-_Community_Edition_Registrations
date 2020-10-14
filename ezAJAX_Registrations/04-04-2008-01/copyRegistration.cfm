<cfsetting showdebugoutput="No" requesttimeout="120" enablecfoutputonly="Yes">

<cfparam name="URL.parms" type="string" default="">
<cfparam name="FORM.parms" type="string" default="">

<cfscript>
	URL.parms = Trim(URLDecode(URL.parms));
	FORM.parms = Trim(URLDecode(FORM.parms));

	if (Len(URL.parms) gt 0) {
		_parms = URL.parms;
	} else if (Len(FORM.parms) gt 0) {
		_parms = FORM.parms;
	}
	pStruct = StructNew();
	if (Len(_parms) gt 0) {
		ar = ListToArray(_parms, '&');
		for (i = 1; i lte ArrayLen(ar); i = i + 1) {
			arEQ = ListToArray(ar[i], '=');
			if (ArrayLen(arEQ) eq 2) {
				pStruct[arEQ[1]] = arEQ[2];
			}
		}
	}
	if ( (IsDefined("pStruct.serverName")) AND (IsDefined("pStruct.filePath")) AND (IsDefined("pStruct.theLicense")) ) {
		_serverName = pStruct.serverName;
		_filePath = pStruct.filePath;
		_theLicense = pStruct.theLicense;
		
		aFilePath = _serverName;
		if ( (FindNoCase('.1.', CGI.SERVER_NAME) eq 0) AND (FindNoCase('.2.', CGI.SERVER_NAME) eq 0) ) {
			aFilePath = '+' & aFilePath;
		}
		eFilePath = ExpandPath(aFilePath);
		isError = false;
		try {
			if (NOT DirectoryExists(eFilePath)) {
				Request.commonCode.cf_makeDirectory(eFilePath);
			}
		} catch (Any e) {
			isError = true;
		}
		if (NOT isError) {
			Request.commonCode.cf_file_write(eFilePath & '\' & _filePath, _theLicense);
		}
	}
</cfscript>
