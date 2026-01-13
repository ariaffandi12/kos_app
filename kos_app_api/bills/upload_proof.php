<?php
include '../db_connect.php';

if(isset($_FILES['proof_image']) && isset($_POST['bill_id'])) {
    $bill_id = $_POST['bill_id'];
    $targetDir = "../uploads/receipts/";
    
    if (!file_exists($targetDir)) mkdir($targetDir, 0777, true);
    
    $fileName = time() . '_' . basename($_FILES["proof_image"]["name"]);
    $targetFilePath = $targetDir . $fileName;

    if(move_uploaded_file($_FILES["proof_image"]["tmp_name"], $targetFilePath)) {
        $stmt = $conn->prepare("UPDATE bills SET proof_image=?, status='Pending' WHERE id=?");
        $stmt->bind_param("si", $fileName, $bill_id);
        
        if($stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "Upload Berhasil"]);
        } else {
            echo json_encode(["status" => "error", "message" => "DB Update Failed"]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "File Upload Failed"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "No File Found"]);
}
?>