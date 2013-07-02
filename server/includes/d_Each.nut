/************************************
*	@Debug-Each[ Players Iterator] 	*
*                                	*
* 	@Author:      @Debug           	*
* 	@Version:     0.3         		*
* 	@Released:    2/07/2013       	*
*                                	*
*************************************/

class dEach {
	Each = array( getMaxPlayers() ) ;
	playerNumber = array ( getMaxPlayers() ) ;
	currCell = 0;
};

local dIterator = dEach();

addEventHandler( "onPlayerConnect",
	function( playerid, name, ip, serial ) {
		dIterator.Each[ dIterator.currCell ] = playerid;
		dIterator.playerNumber[ playerid ] = dIterator.currCell;
		dIterator.currCell++;
	}
);

addEventHandler( "onPlayerDisconnect",
	function( playerid, reason ) {
		if ( playerid < dIterator.currCell - 1 ) {
			dIterator.playerNumber[ dIterator.Each[ dIterator.currCell - 1 ] ] = dIterator.playerNumber[ playerid ];
			dIterator.Each[ dIterator.playerNumber[ playerid ] ] = dIterator.playerNumber[ dIterator.currCell - 1 ];
		}
		dIterator.currCell--;
	}
);

function dIter ( _function ) {
	for ( local id = 0, index = dIterator.currCell; id < index; ++id ) {
		_function ( id ) ;
	} 
}
