 <!DOCTYPE html>
<html>
<body>

<?php
echo "<br><br>";
$birthdayString = "8-9-2015";
$birthdayDate = strtotime($birthdayString);

if(date('d-m') == date('d-m', $birthdayDate)) {
    echo "TOday is your birthday";
}


?>
</body>
</html>
