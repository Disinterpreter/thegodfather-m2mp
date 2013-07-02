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
		return setPlayerPosition ( this.m_iID, vargv[ 0 ].tofloat(), vargv[ 1 ].tofloat(), vargv[ 2 ].tofloat() );
	}
	function SetRotation ( ... ) {
		return setPlayerRotation ( this.m_iID, vargv[ 0 ].tofloat(), vargv[ 1 ].tofloat(), vargv[ 2 ].tofloat() );
	}
	function gethealth() {
		return getPlayerHealth ( this.m_iID );
	}
	function SetHealth ( sHealth ) {
		return setPlayerHealth ( this.m_iID, sHealth );
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
	function getName (  )
	{
		return getPlayerName ( this.m_iID );
	}
	function getVehicle (  )
	{
		return getPlayerVehicle ( this.m_iID );
	}
	function getPing (  )
	{
		return getPlayerPing ( this.m_iID );
	}
};
