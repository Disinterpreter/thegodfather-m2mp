class mySql
{
   
	function AccCheck(playerid)
	{
	    mysql_query( cMySQL, "SELECT `Name` FROM `accounts` WHERE `Name` = '" + player[ playerid ].getName() +"'" );
		mysql_store_result( cMySQL );
		if ( mysql_num_rows( cMySQL ) ) mysql_free_result( cMySQL ) , return 1;
		else mysql_free_result( cMySQL ) , return 0;
	}
	function Register(playerid,password[])
	{
	   mysql_query( cMySQL, "INSERT INTO `accounts` ( `Name`, `Password`, `Skin`, `Admin` ) VALUES ( '" + player[ playerid ].getName() + "', '" + md5( password ) + "', '1', '0' )" ) ;
	}
    function Login(playerid,password[])
	{
	   mysql_query( cMySQL, "Select * FROM `accounts` WHERE `Name` = '" + player[ playerid ].getName() +"' AND `Password` = '" + md5( password ) + "'" );
	   if ( mysql_fetch_row( cMySQL ) ) 
	   {
				playerData[ playerid ].Skin 	= mysql_fetch_field_row( cMySQL, 3 );
				playerData[ playerid ].Admin 	= mysql_fetch_field_row( cMySQL, 4 );
				playerData[ playerid ].Logged 	= 1;

				sendPlayerMessage( playerid, "Вы успешно авторизовались." );
				player[ playerid ].setModel( playerData[ playerid ].Skin );
				player[ playerid ].toggleControl( true ) ;
		}
        else sendPlayerMessage( playerid, "Вы ввели неверный пароль" );							
		mysql_free_result( cMySQL ) ;		
	}
	
};