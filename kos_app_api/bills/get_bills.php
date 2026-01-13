<?php
include '../db_connect.php';

// Ambil user_id dari parameter URL atau body
 $user_id = isset($_GET['user_id']) ? $_GET['user_id'] : 0;

 $sql = "SELECT * FROM bills WHERE user_id='$user_id' ORDER BY created_at DESC";
 $result = $conn->query($sql);
 $bills = [];

while($row = $result->fetch_assoc()) {
    $bills[] = $row;
}
echo json_encode($bills);
?>