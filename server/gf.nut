dofile( "resources/default/server/classes/CPlayer.nut" );
dofile( "resources/default/server/classes/CMysql.nut" );
dofile( "resources/default/server/events/event.nut" );
dofile( "resources/default/server/includes/d_Each.nut" );
dofile( "resources/default/server/functions/function.nut" );


/*Local*/
local player = { };
local mysql = CMysql( );
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
		
		mysql.connect( SQL_HOST, SQL_USER, SQL_PASS, SQL_DB ) ;
		
		 timer ( 
			function( ) {
				dIter (
					function ( id ) {
						if ( isPlayerSpawned( id ) )  {
							local health = player[ id ].getHealth( );
							health < 250.0  && player[ id ].message( "Вы проголодались. Вам срочно нужно поесть!" ), player[ id ].setHealth( --health ) ;
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
		
		player[ playerid ].message( "Добро пожаловать на " + scriptName );
		player[ playerid ].message( "Чтобы прочесть правила нашего сервера нажмите F10" );
		
		mysql.query( "SELECT `Name` FROM `accounts` WHERE `Name` = '" + player[ playerid ].getName() +"'" );
		mysql.store_result( );
		if ( mysql.num_rows( ) ) {
			player[ playerid ].message( "Ваш аккаунт зарегистрирован, пройдите процесс авторизации коммандой /login password.", 255, 204, 0 );
			gAccount[ playerid ] = 1;
		} else {
			player[ playerid ].message( "Этот аккаунт не зарегистрирован, пройдите процесс регистрации коммандой /register password.", 255, 204, 0 );
			gAccount[ playerid ] = 0;
		}
		mysql.free_result( ) ;
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
		mysql.query( "UPDATE `accounts` SET `Admin` = '" + playerData[ playerid ].Admin + "', `Skin` = '" + playerData[ playerid ].Skin + "' WHERE `Name` = '" + player[ playerid ].getName( ) + "'" ) ;
	}
    
    return 1 ;
}

/*Commands*/

addCommandHandler( "w",
	function( playerid, giveplayerid, text ) {
		if ( !isPlayerConnected( giveplayerid.tointeger( ) ) ) {
			return player[ playerid ].message( "Игрок " + giveplayerid.tointeger() + " не в сети" );
		}
		player[ giveplayerid.tointeger( ) ].message(  "От " + player[ playerid ].getName( ) + " [" + playerid + "]: " + text );
		player[ playerid ].message( "К " + player[ giveplayerid.tointeger( ) ].getName( ) + " [" + giveplayerid.tointeger( ) + "]: " + text );
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
			if ( gAccount[ playerid ] == 1 ) return player[ playerid ].message( "Этот аккаунт уже зарегистрирован!" ) ;
			mysql.query( "INSERT INTO `accounts` ( `Name`, `Password`, `Skin`, `Admin` ) VALUES ( '" + player[ playerid ].getName() + "', '" + md5( password ) + "', '1', '0' )" ) ;
			player[ playerid ].message( "Вы успешно зарегистрировались." ) ;
			player[ playerid ].toggleControl( true ) ;
		} else {
			player[ playerid ].message( "Вы уже авторизованы.");
		}
	}
);

addCommandHandler( "login",
	function( playerid, password ) {
		if( playerData[ playerid ].Logged == 0 ) {
			if ( gAccount[ playerid ] == 0 ) { 
				return player[ playerid ].message( "Такого аккаунта не существует!" ) ;
			}
			
			mysql.query( "Select * FROM `accounts` WHERE `Name` = '" + player[ playerid ].getName() +"' AND `Password` = '" + md5( password ) + "'" );
			mysql.store_result( ) ;
			if ( mysql.fetch_row( ) ) {
				playerData[ playerid ].Skin 	= mysql.fetch_field_row( 3 );
				playerData[ playerid ].Admin 	= mysql.fetch_field_row( 4 );
				playerData[ playerid ].Logged 	= 1;
				
				player[ playerid ].message( "Вы успешно авторизовались." );
				player[ playerid ].setModel( playerData[ playerid ].Skin );
				player[ playerid ].toggleControl( true ) ;
			} else {
				player[ playerid ].message( "Вы ввели неверный пароль." );
			}
			mysql.free_result( ) ;
		} else {
			player[ playerid ].message( "Вы уже авторизованы." );
		}
	}
);

addCommandHandler( "kick",
	function( playerid, giveplayerid, text ) {
		if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( giveplayerid.tointeger( ) ) ) {
				return player[ playerid ].message( "Игрок " + giveplayerid.tointeger() + " не в сети" );
			}
			
			sendPlayerMessageToAll( "Администратор '" + player[ playerid ].getName( ) + "' кикнул '" + player[ giveplayerid.tointeger( ) ].getName( ) + "'! Причина: '" + text.tostring() + "'");
			kickPlayer( giveplayerid.tointeger() ) ;
		}
	}
);

addCommandHandler( "getns",
	function( playerid, giveplayerid ) {
		if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( giveplayerid.tointeger( ) ) ) {
				return player[ playerid ].message( "Игрок " + giveplayerid.tointeger() + " не в сети" );
			}
			player[ playerid ].message( "Network Stats игрока '" + player[ giveplayerid.tointeger( ) ].getName( ) + "' : " + player[ giveplayerid.tointeger( ) ].getNetStat( ) );
		}
	}
);

addCommandHandler( "setmodel",
	function( playerid, giveplayerid, skin ) {
		if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( giveplayerid.tointeger( ) ) ) return player[ playerid ].message( "Игрок " + giveplayerid.tointeger() + " не в сети" );
			
			player[ playerid ].message( "Вы установили игроку " + player[ giveplayerid.tointeger( ) ].getName ( ) + " " + skin.tointeger( ) + " модель" ) ;
			player[ giveplayerid.tointeger( ) ].message( "Администратор " + player[ playerid.tointeger( ) ].getName ( ) + " установил вам " + skin.tointeger( ) + " модель" ) ;
			playerData[ giveplayerid.tointeger( ) ].Skin = skin.tointeger( ) ;
			player[ giveplayerid.tointeger( ) ].setModel( playerData[ giveplayerid.tointeger( ) ].Skin );
		}
	}
);

addCommandHandler( "a",
	function( playerid, text ) {
		if ( playerData[ playerid ].Admin.tointeger( ) > 0 ) {
			dIter(
				function( id ) {
					if ( playerData[ id ].Admin.tointeger( ) > 0 ) {
						player[ id ].message( "[A] Администратор: " + player[ playerid ].getName( ) + ": " + text.tostring() ) ;
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
				return player[ playerid ].message( "Игрок " + id.tointeger( ) + " не в сети" );
			}
			
            local pos = player[ id ].getPosition( ) ;
			
            setPlayerPosition( playerid, ( pos[ 0 ] + 1 ).tofloat( ), ( pos[ 1 ] + 1 ).tofloat( ), ( pos[ 2 ] ).tofloat( ) );
            player[ playerid ].message( "Вы телепортировались к " + player[ id ].getName( ) );
            player[ id.tointeger( ) ].message( "К вам телепортировался администратор " + player[ playerid ].getName( ) );
        } else {
            player[ playerid ].message( youCanNot );
        }
   }
);

addCommandHandler( "get",
    function( playerid, id ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( id.tointeger( ) ) ) { 
				return player[ playerid ].message( "Игрок " + id.tointeger( ) + " не в сети" );
			}
			
            local pos = player[ playerid ].getPosition( );
			
            setPlayerPosition( id.tointeger( ), ( pos[ 0 ] + 1 ).tofloat( ), ( pos[ 1 ] + 1 ).tofloat( ), ( pos[ 2 ] ).tofloat( ) );
            player[ playerid ].message( "Вы телепортировали " + player[ id.tointeger( ) ].getName( ) + " к себе." );
            player[ id.tointeger( ) ].message( "Вас телепортировал администратор " + player[ playerid ].getName( ) );
        } else {
            player[ playerid ].message( youCanNot );
        }
	}
);

addCommandHandler( "sethp",
    function( playerid, id, hp ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
			if ( !isPlayerConnected( id.tointeger( ) ) ) { 
				return player[ playerid ].message( "Игрок " + id.tointeger( ) + " не в сети" );
			}
			
            player[ id.tointeger( ) ].setHealth( hp.tofloat() );
        } else {
            player[ playerid ].message( youCanNot );
        }
    }
);

addCommandHandler( "ooc",
	function( playerid, text ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
            sendPlayerMessageToAll( "Администратор: " + player[ playerid ].getName( ) + " [ " + playerid + " ]: " + text.tostring( ) );
        } else {
            player[ playerid ].message( youCanNot );
        }
	}
);

addCommandHandler( "vehicle",
    function( playerid, ... ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
   		local 	id 		= vargv[ 0 ] ,
				pos 	= getPlayerPosition( playerid ) ,
				vehicle = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
					
		setVehicleColour ( vehicle, 255, 0, 255, 0, 255, 255 );
        } else {
            player[ playerid ].message( youCanNot );
		}
    }
);

addCommandHandler( "setadmin",
    function( playerid, id ) {
        if ( playerData[ playerid ].Admin.tointeger() > 0 ) {
		if ( !isPlayerConnected( id.tointeger( ) ) ) { 
			return player[ playerid ].message( "Игрок " + id.tointeger( ) + " не в сети" );
		}
			
		playerData[ id.tointeger( ) ].Admin = 1;
		player[ id.tointeger( ) ].message( "Администратор " + player[ playerid ].getName( ) + " назначил вас администратором!" );
		player[ playerid ].message( "Вы назначили администратором " + player[ id.tointeger( ) ].getName( ) );
        } else {
            player[ playerid ].message( youCanNot );
		}
    }
);
