<?php
include '../db_connect.php';

 $data = json_decode(file_get_contents("php://input"));
 $id = $data->id;
 $roomNumber = $data->room_number;
 $type = $data->type;
 $price = $data->price;
 $status = $data->status;
// Note: Update gambar butuh logika multipart tambahan, di sini update teks saja

 $sql = "UPDATE rooms SET room_number='$roomNumber', type='$type', price='$price', status='$status' WHERE id=$id";

if($conn->query($sql)) {
    echo json_encode(["status" => "success", "message" => "Room updated"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}
?>