component {

	// Module Properties
	this.title       = "Ortus Branding Assets Module";
	this.author      = "Ortus Solutions";
	this.webURL      = "https://github.com/Ortus-Solutions/ortus-artwork";
	this.description = "Shortcode support for Ortus Branding Assets";

	function configure(){

		// Module Settings
		settings = {
			logoAssetsPath = modulePath & "/assets/logos"
		};

		// Interceptors
		interceptors = [
			{ class = "#moduleMapping#.interceptors.LogoInterceptor" }
		];

		// Module Routes
		routes = [
			{
				pattern = "/",
				handler = "logos",
				action  = "index"
			},
			{
				pattern = "/logo/:product/:variant",
				handler = "logos",
				action  = "show"
			}
		];

	}

}