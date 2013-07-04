class CMysql { 
	m_iID = 1;
	
	function connect( iSQL_HOST, iSQL_USER, iSQL_PASS, iSQL_DB ) {
		return mysql_connect( iSQL_HOST, iSQL_USER, iSQL_PASS, iSQL_DB ) ;
	}
	
	function query ( query ) {
		return mysql_query( this.m_iID, query ) ;
	}
	
	function store_result ( ) {
		 return mysql_store_result( this.m_iID ) ;
	}
	
	function free_result ( ) {
		return mysql_free_result( this.m_iID ) ;
	}
	
	function fetch_row ( ) {
		return mysql_fetch_row( this.m_iID ) ;
	}
	
	function num_rows ( ) {
		return mysql_num_rows( this.m_iID ) ;
	}
	
	function fetch_field_row ( fieldIndex ) {
		return mysql_fetch_field_row ( this.m_iID, fieldIndex ) ;
	}
};