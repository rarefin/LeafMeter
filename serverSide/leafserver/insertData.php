<?php
include 'connectDatabase.php';

$location = $_POST['location'];
$defect_percentage = $_POST['defect_percentage'];
$time_stamp = $_POST['time_stamp'];
$salt_name = $_POST['salt_name'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];


$connection = new DatabaseConnector();
$con = $connection->connect();
if($con){
	$database = mysql_select_db("leaf_me_alone"); //'Dhaka', 10, 100, Sodium', 23.810350,90.41355     '$location', '$defect_percentage', '$time_stamp', '$salt_name', '$latitude', '$longitude'
		if($database){
			$insert_query = "INSERT INTO leafs(location, defect_percentage, time_stamp, salt_name, latitude, longitude) values('$location', '$defect_percentage', '$time_stamp', '$salt_name', '$latitude', '$longitude')";
			mysql_query($insert_query);
			$connection->disconnect();
		}else{
			echo "Unable to get data";
		}
}else{
	echo "Unable to connect database.";
}	
?>