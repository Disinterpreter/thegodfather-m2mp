this.isPlayerInRangeOfPoint <- function( playerid, radius, x, y, z ) {
	local pos = getPlayerPosition( playerid );
	return (getDistanceBetweenPoints3D( x, y, z, pos[0], pos[1], pos[2] ) <= radius);
}

this.sendMessageToAllInRadius <- function( message, x, y, z, radius = 25.0 ) {
	dIter (
		function ( id ) {
			if ( isPlayerInRangeOfPoint ( id, radius, x, y, z ) ) {
				sendPlayerMessage( id, message );
			}	
		}
	);
	return 1 ;
}