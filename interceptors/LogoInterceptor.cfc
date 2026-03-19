component {

	property name="logoService" inject="LogoService@oba";

	function cb_onContentRendering( event, interceptData ){

		var content = event.getValue( "renderedContent", "" );

		if ( !len( content ) ) {
			return;
		}

		var shortcodeRegex = '\{\{logo\b[^}]*\}\}';
		var matches = reMatch( shortcodeRegex, content );

		for ( var match in matches ){
			if ( !reFindNoCase( '\bproduct="[^"]+"', match ) ) {
				continue;
			}

			var product = reReplaceNoCase( match, '^.*\bproduct="([^"]+)".*$', '\1' );
			var theme   = "auto";

			if ( reFindNoCase( '\btheme="[^"]*"', match ) ) {
				theme = reReplaceNoCase( match, '^.*\btheme="([^"]*)".*$', '\1' );
			}

			var html = logoService.resolveLogo(
				product = product,
				theme   = len( trim( theme ) ) ? theme : "auto"
			);

			content = replace( content, match, html, "all" );
		}

		event.setValue( "renderedContent", content );
	}
}