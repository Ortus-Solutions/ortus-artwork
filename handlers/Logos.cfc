component {

property name="logoService" inject="LogoService@oba";

/**
 * Default route
 */
function index( event, rc, prc ){
	event.renderData(
		type = "json",
		data = {
			message : "Ortus Artwork Logos Endpoint",
			products : logoService.getProducts()
		}
	);
}

/**
 * Serve a specific logo
 * Example:
 * /ortus-artwork/logos/bxacademy/bxacademy-logo-full-dark
 */
function show( event, rc, prc ){

	var product = rc.product ?: "";
	var variant = rc.variant ?: "";

	var logoPath = logoService.getLogoPath( product, variant );

	if ( !len( logoPath ) ) {
		event.setHTTPHeader( statusCode = 404, statusText = "Logo not found" );
		return;
	}

	event.renderFile(
		file      = logoPath,
		mimeType  = "image/svg+xml"
	);

}


}
