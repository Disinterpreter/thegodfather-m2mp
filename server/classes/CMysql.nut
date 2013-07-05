class CMySQL { 
	m_iID = 1;
	iN=0;
	iErr=-1;
	sBaseName="accounts";
	function connect( iSQL_HOST, iSQL_USER, iSQL_PASS, iSQL_DB ) {
		this.m_iID = mysql_connect( iSQL_HOST, iSQL_USER, iSQL_PASS, iSQL_DB ) ;
		return 1;
	}
	
	function query ( sQuery ) {
		mysql_query( this.m_iID, sQuery ) ;
		this.iErr=mysql_errno(this.m_iID);
		return this.iErr;
	}
	
	function store ( ) {
		mysql_store_result( this.m_iID ) ;
		this.iN=this.num;
		return 1;
	}
	
	function free( ) {
		return mysql_free_result( this.m_iID ) ;
	}
	
	function fetch ( ) {
		return mysql_fetch_row( this.m_iID ) ;
	}
	
	function num ( ) {
		return mysql_num_rows( this.m_iID ) ;
	}
	
	function fetchEx ( sFieldIndex ) {
		return mysql_fetch_field_row ( this.m_iID, sFieldIndex ) ;
	}
	function RegisterPlayer(playerid,sPass)	{
		(this.query("Insert into `" + this.sBaseName + "` (Name,Password) VALUES ('"+ getPlayerName ( playerid ) +"','"+ md5(sPass) +"')")==0)?(return 1):(log("CMySQL::RegisterPlayer Failed. Errno: "+this.iErr),return -1);
	}
	function AccountExists(playerid) {
		(this.query("Select `ID` from `" + this.sBaseName + "` where `Name` = '"+ getPlayerName(playerid) +"'")==0)?(return 1):(log("CMySQL::AccountExists Failed. Errno: "+this.iErr),return -1);
		this.store();
		this.free();
		return !!this.iN;
	}
	function CheckLogin(playerid,sPass)	{
		(this.query("Select * from `" + this.sBaseName + "` where `Name` = '"+ getPlayerName(playerid) +"' AND `Password` = '"+ md5(sPass) +"' LIMIT 1")==0)?(return 1):(log("CMySQL::CheckLogin Failed. Errno: "+this.iErr),return -1);
		this.store();
		(this.iN==1)?(return 1):(this.free(),return 0);
		return !!this.iN;
	}
};