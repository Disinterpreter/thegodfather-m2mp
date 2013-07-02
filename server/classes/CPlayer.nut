class CPlayer { 
	m_iID = -1;
	constructor( iPlayerID ) {
		this.m_iID = iPlayerID;
	}
	function SendMessage ( ... ) {
		if ( !vargv[ 1 ] ) {
			sendPlayerMessage ( this.m_iID, vargv[ 0 ].tostring() );
		else
			sendPlayerMessage ( this.m_iID, vargv[ 0 ].tostring(), vargv[ 1 ] );
		return 1;
	}
	function SetPosition ( ... ) {
		return setPlayerPosition ( this.m_iID, fVargv[ 0 ].tofloat(), fVargv[ 1 ].tofloat(), fVargv[ 2 ].tofloat() );
	}
	function SetRotation ( ... ) {
		return setPlayerRotation ( this.m_iID, fVargv[ 0 ].tofloat(), fVargv[ 1 ].tofloat(), fVargv[ 2 ].tofloat() );
	}
	function GetHealth() {
		return getPlayerHealth ( this.m_iID );
	}
	function SetHealth ( fHealth ) {
		return setPlayerHealth ( this.m_iID, fHealth.tofloat() );
	}
	function SetModel ( sModel ) {
		return setPlayerModel ( this.m_iID, sModel);
	}
	function GiveWeapon ( iWeapon, iAmmo ) {
		return givePlayerWeapon ( this.m_iID, iWeapon, iAmmo );
	}
	function RemoveWeapon ( iWeapon ) {
		return removePlayerWeapon ( this.m_iID, iWeapon );
	}
	function GetSerial () {
		return getPlayerSerial ( this.m_iID );
	}
	function getName() {
		return getPlayerName ( this.m_iID );
	}
	function getVehicle() {
		return getPlayerVehicle ( this.m_iID );
	}
	function getPing() {
		return getPlayerPing ( this.m_iID );
	}
};
