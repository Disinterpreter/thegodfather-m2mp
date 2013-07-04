class CPlayer { 
	m_iID = -1;
	name = "";
	constructor( iPlayerID ) {
		this.m_iID = iPlayerID;
		this.name = getPlayerName ( iPlayerID );
	}
	function toggleControl( toggle ) {
		togglePlayerControls( this.m_iID, toggle );
	}
	function getPosition ( ) {
		return getPlayerPosition( this.m_iID )
	}
	function setPosition ( ... ) {
		return setPlayerPosition ( this.m_iID, vargv[ 0 ].tofloat(), vargv[ 1 ].tofloat(), vargv[ 2 ].tofloat() );
	}
	function setRotation ( ... ) {
		return setPlayerRotation ( this.m_iID, vargv[ 0 ].tofloat(), vargv[ 1 ].tofloat(), vargv[ 2 ].tofloat() );
	}
	function getHealth ( ) {
		return getPlayerHealth ( this.m_iID );
	}
	function setHealth ( sHealth ) {
		return setPlayerHealth ( this.m_iID, sHealth.tofloat() );
	}
	function setModel ( sModel ) {
		return setPlayerModel ( this.m_iID, sModel.tointeger() );
	}
	function giveWeapon ( iWeapon, iAmmo ) {
		return givePlayerWeapon ( this.m_iID, iWeapon, iAmmo );
	}
	function removeWeapon ( iWeapon ) {
		return removePlayerWeapon ( this.m_iID, iWeapon );
	}
	function getSerial ( ) {
		return getPlayerSerial ( this.m_iID );
	}
	function getName ( ) {
		return name;
	}
	function getNetStat ( ) {
		return getPlayerNetworkStats( tihs.m_iID ) ;
	}
	function getVehicle ( ) {
		return getPlayerVehicle ( this.m_iID );
	}
	function getPing ( ) {
		return getPlayerPing ( this.m_iID );
	}
	function setColor ( color ) {
		return setPlayerColour( this.m_iID, color );
	}
};
