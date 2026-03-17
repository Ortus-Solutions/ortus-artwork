component {

	property name="logoService" inject="LogoService@oba";

	function cbui_postPageDisplay( event, interceptData ){

		var page = interceptData.page;
		var content = page.getContent();

		var regex = "\{\{logo\s+product=""([^""]+)""\}\}";
		var matches = reMatch( regex, content );

		for ( var match in matches ){

			var product = reReplace( match, regex, "\1" );
			var html = logoService.resolveLogo( product );

			content = replace( content, match, html, "all" );
		}

		page.setContent( content );
	}

}