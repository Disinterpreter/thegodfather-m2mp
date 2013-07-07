class CVehicle {
	m_iID = -1;

	constructor ( iVehicleID ) {
		this.m_iID = iVehicleID;
	}
   
	function destroy ( ) {
		return destroyVehicle( this.m_iID );
	}
   
	function setPos ( fPosX, fPosY, fPosZ ) {
		return setVehiclePosition( this.m_iID, fPosX, fPosY, fPosZ );
	}
   
	function getPos ( ) {
		return getVehiclePosition( this.m_iID );
	}
   
	function setRot ( fRotX, fRotY, fRotZ ) {
		return setVehicleRotation( this.m_iID, fRotX, fRotY, fRotZ );
	}
   
	function getRot ( ) {
		return getVehicleRotation( this.m_iID );
	}
   
	function repair ( ) {
		return repairVehicle( this.m_iID );
	}
   
	function getModel ( ) {
		return getVehicleModel ( this.m_iID );
	}
   
	function respawn ( ) {
		return respawnVehicle( this.m_iID );
	}
};