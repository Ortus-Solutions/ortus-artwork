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

/**
 * Convert requested theme into the tone token used by asset filenames.
 */
private string function resolveTone( required string theme ){
	return ( arguments.theme == "dark" ) ? "light" : "dark";
}

/**
 * Build the logo filename from individual shortcode arguments.
 */
private string function buildFilename(
	required string product,
	string type = "logo",
	string variant = "full",
	string size = "M",
	string format = "svg",
	string tone = ""
){
	var parts = [
		arguments.product,
		arguments.type,
		arguments.variant
	];

	if ( arguments.variant == "mono" || arguments.type == "logo" ) {
		arrayAppend( parts, arguments.tone );
	}

	arrayAppend( parts, arguments.size );

	return arrayToList( parts, "-" ) & "." & arguments.format;
}

	function resolveLogo(
		required string product,
		string type    = "logo",
		string variant = "full",
		string size    = "M",
		string tone    = "dark",  // direct tone for the filename: light | dark
		string theme   = "",      // set to "auto" to render <picture> auto-switching
		string format  = "svg",
		string class   = ""
	){

		var basePath  = "/modules/oba/assets/logos/#arguments.product#";
		var classAttr = len( trim( arguments.class ) ) ? ' class="#encodeForHTMLAttribute( arguments.class )#"' : "";

		// AUTO THEME — renders <picture> for CSS prefers-color-scheme switching
		if ( arguments.theme == "auto" ){

			var lightFile = buildFilename(
				product = arguments.product,
				type    = arguments.type,
				variant = arguments.variant,
				size    = arguments.size,
				format  = arguments.format,
				tone    = "dark"
			);
			var darkFile = buildFilename(
				product = arguments.product,
				type    = arguments.type,
				variant = arguments.variant,
				size    = arguments.size,
				format  = arguments.format,
				tone    = "light"
			);

			return '<picture>
	<source srcset="#basePath#/SVG/#darkFile#" media="(prefers-color-scheme: dark)">
	<img src="#basePath#/SVG/#lightFile#" alt="#encodeForHTMLAttribute( arguments.product )# logo"#classAttr#>
</picture>';
		}

		// DIRECT TONE — use the tone attribute as-is in the filename
		var file = buildFilename(
			product = arguments.product,
			type    = arguments.type,
			variant = arguments.variant,
			size    = arguments.size,
			format  = arguments.format,
			tone    = arguments.tone
		);

		return '<img src="#basePath#/SVG/#file#" alt="#encodeForHTMLAttribute( arguments.product )# logo"#classAttr#>';
	}


}
