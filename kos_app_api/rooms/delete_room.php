<?php
include '../db_connect.php';

 $data = json_decode(file_get_contents("php://input"));
 $id = $data->id;

 $sql = "DELETE FROM rooms WHERE id=$id";

if($conn->query($sql)) {
    echo json_encode(["status" => "success", "message" => "Room deleted"]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to delete"]);
}
?>