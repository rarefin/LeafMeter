<?php
	include 'connectDatabase.php';
	$connection = new DatabaseConnector();
	$con = $connection->connect();
	$array = array();
	
	if($con){
	// Selecting database
    $database = mysql_select_db("leaf_me_alone");
	if($database){
		$select_query = "select * from leafs";
		$result = mysql_query($select_query) or die(mysql_error());
		
		$i=0;
		
		if(!empty($result)){
			if (mysql_num_rows($result) > 0) {
				while ($row = mysql_fetch_array($result)){
					$array[$i] = array();
					$array[$i][0] = $row["salt_name"];
					$array[$i][1] = $row["latitude"];
					$array[$i][2] = $row["longitude"];
					
					$i++;
				}
			}
		}
		
	}else{
		echo "Unable to select database.";
	}
	}else{
		echo "Database is connection is failed.";
	}

?>

<html>
<head>
	<title>
		Leaf Meter
	</title>
	<link rel="icon" type="image/ico" href="res/leafMeter_title_picture.png" />
	<link rel="stylesheet" href="style.css"/>
	
	<script src="https://maps.googleapis.com/maps/api/js"></script>
    <script>
      function initialize() {
        var mapCanvas = document.getElementById('content');
        var mapOptions = {
          center: new google.maps.LatLng(23.7000, 90.3667),
          zoom: 7,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        var map = new google.maps.Map(mapCanvas, mapOptions);
		var locations = <?php echo json_encode($array); ?>;
		for (i = 0; i < locations.length; i++) {
		marker = new google.maps.Marker({ position: new google.maps.LatLng(locations[i][1], locations[i][2]), title: locations[i][0], map: map }); }

      }
      google.maps.event.addDomListener(window, 'load', initialize);
    </script>
</head>

<body>
	<div id="cover">
		<img id="wallPaper" src='res/leafMeter_wallpaper_home.png'/>
		<div id="profile">
			<h1 id="profile_name">Leaf Meter</h1>
			<img id="profile_picture" src='res/leafMeter_icon.png'/>
		</div>
	</div>
	
	<!------------------------------------------------------------------------------------------>
	
	<div id="dashboard">
		<a href="#" class="dashboard_item">HOME</a>
		<a href="#" class="dashboard_item">STATISTICS</a>
		<a href="#" class="dashboard_item">ABOUT</a>
		<a href="#" class="dashboard_item">CONTACT</a>
	</div>
	
	<!------------------------------------------------------------------------------------------>
	
	<div id="welcome">
		<h3 id="welcome_heading">Welcome!</h3>
		<div id="welcome_message">
			<p>
				Welcome to the website of LEAf METER. 
			</p>
		</div>
	</div>
	
	<!------------------------------------------------------------------------------------------>
	<div id="content">
	
	</div>
	<!------------------------------------------------------------------------------------------>
	
	<div id="ending">
		<a href="http://en.wikipedia.org/wiki/Chlorosis" target="_blank" class="ending_item">Chlorosis</a>
		<a href="http://en.wikipedia.org/wiki/Nitrogen_deficiency" target="_blank" class="ending_item">Nitrogen deficiency</a>
		<a href="http://en.wikipedia.org/wiki/Iron_deficiency_%28plant_disorder%29" target="_blank" class="ending_item">Iron deficiency </a>
		<a href="http://en.wikipedia.org/wiki/Boron_deficiency_%28plant_disorder%29" target="_blank" class="ending_item">Boron deficiency</a>
		<a href="http://en.wikipedia.org/wiki/Phosphorus_deficiency" class="ending_item">Phosphorus deficiency</a>
		<br/>
		<a href="http://en.wikipedia.org/wiki/Magnesium_deficiency_%28plants%29" target="_blank" class="ending_item">Magnesium deficiency</a>
		<a href="http://en.wikipedia.org/wiki/Manganese_deficiency_%28plant%29" target="_blank" class="ending_item">Manganese deficiency</a>
		<a href="http://en.wikipedia.org/wiki/Potassium_deficiency_%28plants%29" class="ending_item">Potassium deficiency</a>
		<a href="http://en.wikipedia.org/wiki/Zinc_deficiency_%28plant_disorder%29" class="ending_item">Zinc deficiency</a>
	</div>
</body>
	
</html>