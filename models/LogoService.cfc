component singleton {

property name="moduleSettings" inject="coldbox:moduleSettings:oba";

/**
 * Returns the base path of the logos directory
 */
function getAssetsPath(){
	return moduleSettings.logoAssetsPath;
}

/**
 * Get all available products (folders inside assets/logos)
 */
function getProducts(){
	var path = getAssetsPath();
	return directoryList( path, false, "name" );
}

/**
 * Get all logo variants for a given product
 */
function getVariants( required string product ){
	var productPath = getAssetsPath() & "/" & arguments.product;

	if ( !directoryExists( productPath ) ) {
		return [];
	}

	return directoryList( productPath, false, "name", "*.svg" );
}

/**
 * Get the full path to a logo variant
 */
function getLogoPath(
	required string product,
	required string variant
){

	var path = getAssetsPath() & "/" & arguments.product & "/" & arguments.variant & ".svg";

	if ( fileExists( path ) ) {
		return path;
	}

	return "";
}

	function resolveLogo(
		required string product,
		string type = "logo",
		string variant = "full",
		string tone = "",
		string size = "M",
		string theme = "auto", // light | dark | auto
		string format = "svg",
		string cssClass = ""
	){

		var product = lCase( trim( arguments.product ) );
		var type    = lCase( trim( arguments.type ) );
		var variant = lCase( trim( arguments.variant ) );
		var size    = uCase( trim( arguments.size ) );
		var theme   = lCase( trim( arguments.theme ) );
		var tone    = lCase( trim( arguments.tone ) );
		var format  = lCase( trim( arguments.format ) );
		var hasExplicitTone = len( tone );
		var cssAttr = len( trim( arguments.cssClass ) ) ? ' class="#encodeForHTMLAttribute( trim( arguments.cssClass ) )#"' : "";

		var basePath = "/modules/oba/assets/logos/#product#";

		var function themeToTone( required string targetTheme ){
			// In dark UI we use light logos, and vice versa.
			return ( arguments.targetTheme == "dark" ) ? "light" : "dark";
		}

		var function buildFilename( required string tone, boolean includeTone = true ){
			var parts = [ product, type, variant ];

			if ( arguments.includeTone ) {
				arrayAppend( parts, arguments.tone );
			}

			arrayAppend( parts, size );

			return arrayToList( parts, "-" ) & "." & format;
		}

		var function resolveFilename( required string tone ){
			var conventionFile = buildFilename( tone = arguments.tone, includeTone = true );
			var conventionPath = getAssetsPath() & "/#product#/SVG/#conventionFile#";

			if ( fileExists( conventionPath ) ) {
				return conventionFile;
			}

			var legacyFile = buildFilename( tone = arguments.tone, includeTone = false );
			var legacyPath = getAssetsPath() & "/#product#/SVG/#legacyFile#";

			if ( fileExists( legacyPath ) ) {
				return legacyFile;
			}

			return conventionFile;
		}

		if ( !len( tone ) ) {
			tone = ( theme == "auto" ) ? themeToTone( "light" ) : themeToTone( theme );
		}

		if ( theme == "auto" && !hasExplicitTone ){
			var lightTone = themeToTone( "light" );
			var darkTone  = themeToTone( "dark" );

			var lightFile = resolveFilename( lightTone );
			var darkFile  = resolveFilename( darkTone );

			return '
			<picture>
				<source srcset="#basePath#/SVG/#darkFile#" media="(prefers-color-scheme: dark)">
				<img src="#basePath#/SVG/#lightFile#" alt="#encodeForHTMLAttribute( product )# logo"#cssAttr#>
			</picture>
			';
		}

		var file = resolveFilename( tone );

		return '<img src="#basePath#/SVG/#file#" alt="#encodeForHTMLAttribute( product )# logo"#cssAttr#>';
	}


}
