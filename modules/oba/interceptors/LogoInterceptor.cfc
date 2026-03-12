component {

	property name="log" inject="logbox:logger:{this}";

	/**
	 * Intercepts ContentBox content before rendering
	 */
	function cb_onContentRendering( event, interceptData ) {

		// ContentBox passes the content in interceptData
		var content = interceptData.content ?: "";

		// For now we only log to verify interceptor is running
		log.info( "OBA LogoInterceptor triggered" );

	}

}