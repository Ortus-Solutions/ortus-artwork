component {

	this.title       = "Ortus Branding Assets Module";
	this.author      = "Ortus Solutions";
	this.webURL      = "https://github.com/Ortus-Solutions/ortus-artwork";
	this.description = "Shortcode support for Ortus Branding Assets";

	function configure() {

		// Register module interceptors
		interceptors = [
			{ class = "#moduleMapping#.interceptors.LogoInterceptor" }
		];

	}

}