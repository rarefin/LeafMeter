<?php
    /**
 * A class file to connect to database
 */
class DatabaseConnector{
    /**
     * Function to connect with database
     */
    function connect() { 
		$DB_SERVER = "localhost";
		$DB_USER = "root";
		$DB_PASSWORD = "";
		$DB_DATABASE = "leaf_me_alone";
        // Connecting to mysql database
        $connection = mysql_connect($DB_SERVER, $DB_USER, $DB_PASSWORD);
        return $connection;
    }
 
    /**
     * Function to close db connection
     */
    function disconnect() {
        mysql_close();
    }
}
?>