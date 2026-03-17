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
		string size = "M",
		string theme = "light", // light | dark | auto
		string format = "svg"
	){

		var basePath = "/modules/oba/assets/logos/#arguments.product#";

		// theme → tone (invertido)
		var function resolveTone( theme ){
			return ( theme == "dark" ) ? "light" : "dark";
		}

		// construir filename dinámico
		var function buildFilename( tone="" ){

			var parts = [
				arguments.product,
				arguments.type,
				arguments.variant
			];

			// solo agregar tone si aplica
			if ( arguments.variant == "mono" || arguments.type == "logo" ) {
				arrayAppend( parts, tone );
			}

			arrayAppend( parts, arguments.size );

			return arrayToList( parts, "-" ) & "." & arguments.format;
		}

		// AUTO THEME
		if ( arguments.theme == "auto" ){

			var lightTone = resolveTone( "light" );
			var darkTone  = resolveTone( "dark" );

			var lightFile = buildFilename( lightTone );
			var darkFile  = buildFilename( darkTone );

			return '
			<picture>
				<source srcset="#basePath#/SVG/#darkFile#" media="(prefers-color-scheme: dark)">
				<img src="#basePath#/SVG/#lightFile#" alt="#arguments.product# logo">
			</picture>
			';
		}

		// MANUAL THEME
		var tone = resolveTone( arguments.theme );
		var file = buildFilename( tone );

		return '<img src="#basePath#/SVG/#file#" alt="#arguments.product# logo">';
	}


}
