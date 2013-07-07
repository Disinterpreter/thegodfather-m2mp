this.isPlayerInRangeOfPoint <- function ( playerid, radius, x, y, z ) {
	local pos = getPlayerPosition( playerid );
	return (getDistanceBetweenPoints3D( x, y, z, pos[0], pos[1], pos[2] ) <= radius);
}

this.sendMessageToAllInRadius <- function ( message, x, y, z, radius = 25.0 ) {
	dIter (
		function ( id ) {
			if ( isPlayerInRangeOfPoint ( id, radius, x, y, z ) ) {
				sendPlayerMessage( id, message );
			}	
		}
	);
	return 1 ;
}

this.CreateVehicle <- function ( iModel, fX, fY,fZ, fRX, fRY, fRZ ) {
	local vehicleId = createVehicle( iModel, fX, fY,fZ, fRX, fRY, fRZ );
	if ( vehicleId != INVALID_ENTITY_ID ) {
		iVehicle[ vehicleId ] <- { };
		iVehicle[ vehicleId ] <- CVehicle( vehicleId );
	}
	return vehicleId;
}

this.DestroyVehicle <- function ( vehicleid ) {
	iVehicle[ vehicleid ].destroy( );
	delete iVehicle[ vehicleid ];
	return 1;
}