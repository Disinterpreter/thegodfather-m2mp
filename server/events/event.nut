addEventHandler( "onScriptError",
	function( type, line, column, error ){
		::print( "Script Error: Type: " + type + ", Line: " + line + ", Column: " + column + ", Error: " + error );
	}
);