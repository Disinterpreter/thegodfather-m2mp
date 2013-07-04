dofile( "resources/default/server/classes/CPlayer.nut" );
dofile( "resources/default/server/events/event.nut" );
dofile( "resources/default/server/includes/d_Each.nut" );
dofile( "resources/default/server/functions/function.nut" );


/*Local*/
local player = { };
local cMySQL;
local gAccount = array( getMaxPlayers() ) ;
local playerData = { };

/*Const*/
const scriptName 	= "The Godfather";
const youCanNot 	= "Вам недоступна данная функция.";

const SQL_HOST		= "localhost";
const SQL_DB		= "m2mp";
const SQL_USER		= "root";
const SQL_PASS		= "";

addEventHandler( "onScriptInit",
	function() {
		log( scriptName + " Loaded!" );
		setGameModeText( "The Godfather v 0.1" );
		setMapName( "Empire Bay" );
		
		cMySQL = mysql_connect( SQL_HOST, SQL_USER, SQL_PASS, SQL_DB );
		
		 timer ( 
			function( ) {
				dIter (
					function ( id ) {
						if ( isPlayerSpawned( id ) )  {
							local health = player[ id ].getHealth( );
							health < 250.0  && sendPlayerMessage( id, "Вы проголодались. Вам срочно нужно поесть!" ), player[ id ].setHealth( --health ) ;
						}
					}
				);
			}
			, 60000
			, -1 
		);
	}
);

addEventHandler ( "onScriptExit",
	function() {
	
	}
);

addEventHandler( "onPlayerConnect",
	function( playerid, name, ip, serial ) {
		player[ playerid ] <- { };
		player[ playerid ] <- CPlayer( playerid ) ;
		
		playerData[ playerid ] 			<- { };
		playerData[ playerid ].Logged 	<- 0;
		playerData[ playerid ].Admin 	<- 0;
		playerData[ playerid ].Skin 	<- 1;
		
		sendPlayerMessageToAll( "~ " + player[ playerid ].getName() + " присоединился. Сейчас игроков на сервере: " + getPlayerCount() + "/" + getMaxPlayers(), 0, 255, 0 );
		
		sendPlayerMessage( playerid, "Добро пожаловать на " + scriptName );
		sendPlayerMessage( playerid, "Чтобы прочесть правила нашего сервера нажмите F10" );
		
		mysql_query( cMySQL, "SELECT `Name` FROM `accounts` WHERE `Name` = '" + player[ playerid ].getName() +"'" );
		mysql_store_result( cMySQL );
		if ( mysql_num_rows( cMySQL ) ) {
			sendPlayerMessage( playerid, "Ваш аккаунт зарегистрирован, пройдите процесс авторизации коммандой /login password.", 255, 204, 0 );
			gAccount[ playerid ] = 1;
		} else {
			sendPlayerMessage( playerid, "Этот аккаунт не зарегистрирован, пройдите процесс регистрации коммандой /register password.", 255, 204, 0 );
			gAccount[ playerid ] = 0;
		}
		mysql_free_result( cMySQL ) ;
	}
);

addEventHandler( "onPlayerDisconnect",
	function( playerid, reason ) {
		playerSave( playerid ) ;
		sendPlayerMessageToAll( "~ " + player[ playerid ].getName( ) + " отключился.", 255, 0, 23 );
		delete player[ playerid ] ;
		delete playerData[ playerid ] ;
	}
);

addEventHandler( "onPlayerSpawn",
	function( playerid ) {
		player[ playerid ].toggleControl( false ) ;
		player[ playerid ].setPosition( -1551.560181, -169.915466, -19.672523 );
		player[ playerid ].setHealth( 500.0 );
		player[ playerid ].setColor( 0xFFFFFFFF );
	}
);

addEventHandler( "onPlayerChat",
	function( playerid, chattext ) {
		local pos = player[ playerid ].getPosition( );
		return sendMessageToAllInRadius( "- " + player[ playerid ].getName() + " сказал: " + chattext, pos[ 0 ], pos[ 1 ], pos[ 2 ] );
	}
);

addEventHandler( "onPlayerDeath",
	function( playerid, killerid ) {
	
	}
);

/*Functions*/

this.playerSave <- function( playerid ) {
	if ( playerData[ playerid ].Logged == 1 ) {
		mysql_query( cMySQL, "UPDATE `accounts` SET `Admin` = '" + playerData[ playerid ].Admin + "', `Skin` = '" + playerData[ playerid ].Skin + "' WHERE `Name` = '" + player[ playerid ].getName( ) + "'" ) ;
	}
    
    return 1 ;
}

/*Commands*/

addCommandHandler( "w",
	function( playerid, giveplayerid, text ) {
		if ( !isPlayerConnected( giveplayerid.tointeger( ) ) ) {
			return sendPlayerMessage( playerid, "Игрок " + giveplayerid.tointeger() + " не в сети" );
		}
		sendPlayerMessage( giveplayerid.tointeger(), "От " + player[ playerid ].getName( ) + " [" + playerid + "]: " + text );
		sendPlayerMessage( playerid, "К " + player[ giveplayerid.tointeger( ) ].getName( ) + " [" + giveplayerid.tointeger( ) + "]: " + text );
	}
);

addCommandHandler( "s",
	function( playerid, text ) {
		local position = player[ playerid ].getPosition( );
		sendMessageToAllInRadius( "- " + player[ playerid ].getName( ) + " крикнул: " + text, position[ 0 ], position[ 1 ], position[ 2 ], 40.0 );
	}
);

addCommandHandler( "register",
	function( playerid, password ) {
		if( playerData[ playerid ].Logged == 0 ) {
			if ( gAccount[ playerid ] == 1 ) return sendPlayerMessage( playerid, "Этот аккаунт уже зарегистрирован!" ) ;
			mysql_query( cMySQL, "INSERT INTO `accounts` ( `Name`, `Password`, `Skin`, `Admin` ) VALUES ( '" + player[ playerid ].getName() + "', '" + md5( password ) + "', '1', '0' )" ) ;
			sendPlayerMessage( playerid, "Вы успешно зарегистрировались." ) ;
			player[ playerid ].toggleControl( true ) ;
		} else {
			sendPlayerMessage(playerid, "Вы уже авторизованы.");
		}
	}
);

addCommandHandler( "login",
	function( playerid, password ) {
		if( playerData[ playerid ].Logged == 0 ) {
			if ( gAccount[ playerid ] == 0 ) { 
				return sendPlayerMessage( playerid, "Такого аккаунта не существует!" ) ;
			}
			
			mysql_query( cMySQL, "Select * FROM `accounts` WHERE `Name` = '" + player[ playerid ].getName() +"' AND `Password` = '" + md5( password ) + "'" );
			mysql_store_result( cMySQL ) ;
			if ( mysql_fetch_row( cMySQL ) ) {
				playerData[ playerid ].Skin 	= mysql_fetch_field_row( cMySQL, 3 );
				playerData[ playerid ].Admin 	= mysql_fetch_field_row( cMySQL, 4 );
				playerData[ playerid ].Logged 	= 1;
				
				sendPlayerMessage( playerid, "Вы успешно авторизовались." );
				player[ playerid ].setModel( playerData[ playerid ].Skin );
				player[ playerid ].toggleControl( true ) ;
			} else {
				sendPlayerMessage( playerid, "Вы ввели неверный пароль." );
			}
			mysql_free_result( cMySQL ) ;
		} else {
			sendPlayerMessage( playerid, "Вы уже авторизованы." );
		}
	}
);

addCommandHandler( "kick",
	function( playerid, giveplayerid, text ) {
		if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( giveplayerid.tointeger( ) ) ) {
				return sendPlayerMessage( playerid, "Игрок " + giveplayerid.tointeger() + " не в сети" );
			}
			kickPlayer( giveplayerid.tointeger() ) ;
			sendPlayerMessageToAll( "Администратор '" + player[ playerid ].getName( ) + "' кикнул '" + player[ id.tointeger( ) ].getName( ) + "'! Причина: '" + text.tostring() + "'");
		}
	}
);

addCommandHandler( "getns",
	function( playerid, giveplayerid ) {
		if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( giveplayerid.tointeger( ) ) ) {
				return sendPlayerMessage( playerid, "Игрок " + giveplayerid.tointeger() + " не в сети" );
			}
			sendPlayerMessage( playerid, "Network Stats игрока '" + player[ giveplayerid.tointeger( ) ].getName( ) + "' : " + player[ id.tointeger( ) ].getNetStat( ) );
		}
	}
);

addCommandHandler( "setmodel",
	function( playerid, giveplayerid, skin ) {
		if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( giveplayerid.tointeger( ) ) ) {
				return sendPlayerMessage( playerid, "Игрок " + giveplayerid.tointeger() + " не в сети" );
			}
			sendPlayerMessage( playerid, "Вы установили игроку " + player[ giveplayerid.tointeger( ) ].getName ( ) + " " + skin.tointeger( ) + " модель" ) ;
			sendPlayerMessage( giveplayerid.tointeger( ), "Администратор " + player[ playerid.tointeger( ) ].getName ( ) + " установил вам " + skin.tointeger( ) + " модель" ) ;
		}
	}
);

addCommandHandler( "a",
	function( playerid, text ) {
		if ( playerData[ playerid ].Admin.tointeger( ) > 0 ) {
			dIter(
				function( id ) {
					if ( playerData[ id ].Admin.tointeger( ) > 0 ) {
						sendPlayerMessage( id, "[A] Администратор: " + player[ playerid ].getName( ) + text.tostring() ) ;
					}
				}
			);
		}
	}
);

addCommandHandler( "goto",
    function( playerid, id ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( id.tointeger( ) ) ) { 
				return sendPlayerMessage( playerid, "Игрок " + id.tointeger( ) + " не в сети" );
			}
			
            local pos = player[ id ].getPosition( ) ;
			
            setPlayerPosition( playerid, ( pos[ 0 ] + 1 ).tofloat( ), ( pos[ 1 ] + 1 ).tofloat( ), ( pos[ 2 ] ).tofloat( ) );
            sendPlayerMessage( playerid, "Вы телепортировались к " + player[ id ].getName( ) );
            sendPlayerMessage( id, "К вам телепортировался администратор " + player[ playerid ].getName( ) );
        } else {
            sendPlayerMessage( playerid, youCanNot );
        }
   }
);

addCommandHandler( "get",
    function( playerid, id ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( id.tointeger( ) ) ) { 
				return sendPlayerMessage( playerid, "Игрок " + id.tointeger( ) + " не в сети" );
			}
			
            local pos = player[ playerid ].getPosition( );
			
            setPlayerPosition( id.tointeger( ), ( pos[ 0 ] + 1 ).tofloat( ), ( pos[ 1 ] + 1 ).tofloat( ), ( pos[ 2 ] ).tofloat( ) );
            sendPlayerMessage( playerid, "Вы телепортировали " + player[ id.tointeger( ) ].getName( ) + " к себе." );
            sendPlayerMessage( id.tointeger( ), "Вас телепортировал администратор " + player[ playerid ].getName( ) );
        } else {
            sendPlayerMessage( playerid, youCanNot );
        }
	}
);

addCommandHandler( "sethp",
    function( playerid, id, hp ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( id.tointeger( ) ) ) { 
				return sendPlayerMessage( playerid, "Игрок " + id.tointeger( ) + " не в сети" );
			}
			
            player[ id.tointeger( ) ].setHealth( hp.tofloat() );
        } else {
            sendPlayerMessage( playerid, youCanNot );
        }
    }
);

addCommandHandler( "ooc",
	function( playerid, text ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
            sendPlayerMessageToAll( "Администратор: " + player[ playerid ].getName( ) + " [ " + playerid + " ]: " + text.tostring( ) );
        } else {
            sendPlayerMessage( playerid, youCanNot );
        }
	}
);

addCommandHandler( "vehicle",
    function( playerid, ... ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
   		local 	id 	= vargv[ 0 ] ,
			pos 	= getPlayerPosition( playerid ) ,
			vehicle = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
					
    		setVehicleColour ( vehicle, 255, 0, 255, 0, 255, 255 );
        } else {
            sendPlayerMessage( playerid, youCanNot );
	}
    }
);

addCommandHandler( "setadmin",
    function( playerid, id ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
		if ( !isPlayerConnected( id.tointeger( ) ) ) { 
			return sendPlayerMessage( playerid, "Игрок " + id.tointeger( ) + " не в сети" );
		}
			
		playerData[ id.tointeger( ) ].Admin = 1;
            	sendPlayerMessage( id.tointeger( ), "Администратор " + player[ playerid ].getName( ) + " назначил вас администратором!" );
		sendPlayerMessage( playerid, "Вы назначили администратором " + player[ id.tointeger( ) ].getName( ) );
        } else {
            sendPlayerMessage( playerid, youCanNot );
	}
    }
);
