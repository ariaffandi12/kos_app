<?php
include '../db_connect.php';
 $data = json_decode(file_get_contents("php://input"));

if(isset($data->id) && isset($data->status)) {
    $id = mysqli_real_escape_string($conn, $data->id);
    $status = mysqli_real_escape_string($conn, $data->status);

    $sql = "UPDATE complaints SET status='$status' WHERE id='$id'";

    if($conn->query($sql)) {
        echo json_encode(["status" => "success", "message" => "Status updated"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Update failed"]);
    }
}
?>