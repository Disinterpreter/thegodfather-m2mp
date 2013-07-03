local scr = getScreenSize ( );
guiCreateElement( ELEMENT_TYPE_IMAGE, "logo.png", scr[0] - 365, scr[1] - 100, 365, 100);

bindKey( "f10", "up",
	function() {
		showCursor( !isCursorShowing() );
	}
);

addEventHandler( "onGuiElementClick",
	function( element ) {
	
	}
);