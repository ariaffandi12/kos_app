<?php
include '../db_connect.php';

 $id = isset($_GET['id']) ? $_GET['id'] : 0;
 $sql = "SELECT * FROM bills WHERE id='$id'";
 $result = $conn->query($sql);

if($result->num_rows > 0) {
    echo json_encode($result->fetch_assoc());
} else {
    echo json_encode(["status" => "error", "message" => "Bill not found"]);
}
?>