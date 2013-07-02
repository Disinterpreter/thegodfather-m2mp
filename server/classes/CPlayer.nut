class CPlayer
{ 
	m_iID = -1;
	constructor( iPlayerID )
	{
		this.m_iID = iPlayerID;
	}
	function SendMessage ( sText )
	{
		return sendPlayerMessage ( this.m_iID, sText );
	}
	function SendMessageToAll ( sText )
	{
		return sendPlayerMessageToAll ( sText );
	}
	function SetPosition ( fX, fY, fZ )
	{
		return setPlayerPosition ( this.m_iID, fX, fY, fZ );
	}
	function SetRotation ( fX, fY, fZ )
	{
		return setPlayerRotation ( this.m_iID, fX, fY, fZ );
	}
	function SetHealth ( sHealth )
	{
		return setPlayerHealth ( this.m_iID, sHealth );
	}
	function SetModel ( sModel )
	{
		return setPlayerModel ( this.m_iID, sModel );
	}
	function GiveWeapon ( iWeapon, iAmmo )
	{
		return givePlayerWeapon ( this.m_iID, iWeapon, iAmmo );
	}
	function RemoveWeapon ( iWeapon )
	{
		return removePlayerWeapon ( this.m_iID, iWeapon );
	}
	function GetSerial ()
	{
		return getPlayerSerial ( this.m_iID );
	}
	
};

function testf ( iPlayerID )
{
	local pPlayer = CPlayer( iPlayerID );
	//pPlayer.SetHealth ( 500.0 );
	pPlayer.SendMessage ( "test" );
	pPlayer.SendMessage ( pPlayer.GetSerial () );
}
addCommandHandler ( "cmd", testf );
