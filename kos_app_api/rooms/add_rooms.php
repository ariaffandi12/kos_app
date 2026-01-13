<?php
include '../db_connect.php';

// Cek apakah ada gambar
 $imageName = "";
if(isset($_FILES['room_image'])) {
    $targetDir = "../uploads/rooms/";
    if (!file_exists($targetDir)) mkdir($targetDir, 0777, true);
    
    $imageName = time() . '_' . basename($_FILES["room_image"]["name"]);
    $targetFilePath = $targetDir . $imageName;
    
    // Upload file fisik
    move_uploaded_file($_FILES["room_image"]["tmp_name"], $targetFilePath);
}

// Ambil data JSON lainnya (jika dikirim via body) atau form data
// Asumsi dikirim sebagai Multipart Form Data (karena ada gambar)
 $roomNumber = $_POST['room_number'];
 $type = $_POST['type'];
 $price = $_POST['price'];
 $status = isset($_POST['status']) ? $_POST['status'] : 'Available';

 $sql = "INSERT INTO rooms (room_number, type, price, status, image_url) VALUES ('$roomNumber', '$type', '$price', '$status', '$imageName')";

if($conn->query($sql)) {
    echo json_encode(["status" => "success", "message" => "Room added successfully"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}
?>