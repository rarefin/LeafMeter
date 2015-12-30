<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include 'connectDatabase.php';

$connection = new DatabaseConnector();
$con = $connection->connect();
$response = array();
if($con){
	// Selecting database
    $database = mysql_select_db("leaf_me_alone");
	if($database){
		$select_query = "select * from leafs";
		$result = mysql_query($select_query) or die(mysql_error());
		if(!empty($result)){
			if (mysql_num_rows($result) > 0) {
				$response["leafs"] = array();
				while ($row = mysql_fetch_array($result)){
					$leaf = array();
					$leaf["id"] = $row["id"];
					$leaf["location"] = $row["location"];
					$leaf["defect_percentage"] = $row["defect_percentage"];
					$leaf["time_stamp"] = $row["time_stamp"];
					$leaf["salt_name"] = $row["salt_name"];
					array_push($response["leafs"], $leaf);
				}
				$response["success"] = 1;
				echo json_encode($response);
			}else {
				$response["success"] = 0;
				$response["message"] = "No found";
				echo json_encode($response);
			}
		}
	}else{
		echo "Unable to select database.";
	}
}else{
	echo "Database is connection is failed.";
}
$connection->disconnect();
?>