<?php
header("Access-Control-Allow-Origin: *");
$arr = null;
// Create connection
$conn = new mysqli("localhost", "flutter_160419118", "ubaya", "flutter_160419118");
// Check connection
if ($conn->connect_error) {
  $arr= ["result"=>"error","message"=>"unable to connect"];
}

extract($_POST);
$sql = "SELECT * FROM users where username=? and password=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss",$username,$password);
$stmt->execute();
$result = $stmt->get_result();
if ($result->num_rows > 0) {
$r=mysqli_fetch_assoc($result);
$arr=["result"=>"success","user_name"=>$r['username']];
} else {
$arr= ["result"=>"error","message"=>"sql error: $sql"];
}
echo json_encode($arr);

?>