<?php
include '../db_connect.php';
 $sql = "SELECT * FROM rooms ORDER BY id ASC";
 $result = $conn->query($sql);
 $rooms = [];

while($row = $result->fetch_assoc()) {
    $rooms[] = $row;
}
echo json_encode($rooms);
?>