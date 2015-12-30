<?php	
$image_name = basename($_FILES['uploaded_file']['name']);
$target_path = "E:/Duits/imgProc/input/"; // Directory of input images
$target_path = $target_path . $image_name;

$result_path = "E:/Duits/imgProc/output/"; // Directory of processed result
$file_name = "result.txt";

if (!empty($_FILES['uploaded_file'])) {
   if(move_uploaded_file($_FILES['uploaded_file']['tmp_name'], $target_path)) {
		// calling bat file to start Matlab code
		system('startMatlab.bat');
		while(!file_exists($result_path.$file_name)){
			// Waiting in loop for completing image processing
		}
		$resultFile = fopen($result_path.$file_name, "r") or die("Unable to open file!");
		$result = fgets($resultFile);
		fclose($resultFile);
	
		copy($target_path, 'Processed_Images/'.$image_name);
		echo $result;	
	} else{
		echo "Unable to receive image.";
	}
} else {
   echo "You are unable to send image";
}


?>