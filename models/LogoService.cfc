component singleton {

```
property name="moduleSettings" inject="coldbox:moduleSettings:ortus-artwork";

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
```

}
