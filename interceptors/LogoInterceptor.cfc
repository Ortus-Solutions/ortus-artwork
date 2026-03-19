component {

	property name="logoService" inject="LogoService@oba";

	function cb_onContentRendering( event, interceptData ){

		var hasBuilder        = isStruct( arguments.interceptData ) && structKeyExists( arguments.interceptData, "builder" );
		var hasRenderedString = isStruct( arguments.interceptData ) && structKeyExists( arguments.interceptData, "renderedContent" );
		var content           = "";

		if ( hasBuilder ) {
			content = arguments.interceptData.builder.toString();
		} else if ( hasRenderedString ) {
			content = arguments.interceptData.renderedContent;
		} else {
			return;
		}

		if ( !len( trim( content ) ) ) {
			return;
		}

		var shortcodeRegex = '\{\{logo\b[^}]*\}\}';
		var matches        = reMatchNoCase( shortcodeRegex, content );

		for ( var match in matches ){
			if ( !reFindNoCase( '\bproduct="[^"]+"', match ) ) {
				continue;
			}

			var html = logoService.resolveLogo(
				product = parseAttr( match, "product" ),
				type    = parseAttr( match, "type",    "logo" ),
				variant = parseAttr( match, "variant", "full" ),
				tone    = parseAttr( match, "tone",    "dark" ),
				size    = parseAttr( match, "size",    "M" ),
				theme   = parseAttr( match, "theme",   "" ),
				class   = parseAttr( match, "class",   "" )
			);

			content = replaceNoCase( content, match, html, "all" );
		}

		if ( hasBuilder ) {
			arguments.interceptData.builder.replace(
				javacast( "int", 0 ),
				arguments.interceptData.builder.length(),
				content
			);
		} else {
			arguments.interceptData.renderedContent = content;
		}
	}

	private string function parseAttr( required string shortcode, required string attrName, string defaultValue="" ){
		if ( reFindNoCase( '\b' & arguments.attrName & '="([^"]*)"', arguments.shortcode ) ) {
			return trim( reReplaceNoCase( arguments.shortcode, '^.*\b' & arguments.attrName & '="([^"]*)".*$', '\1' ) );
		}
		return arguments.defaultValue;
	}
}