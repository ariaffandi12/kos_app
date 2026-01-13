<?php
include '../db_connect.php';
 $data = json_decode(file_get_contents("php://input"));

if(isset($data->user_id) && isset($data->room_number) && isset($data->issue)) {
    $user_id = mysqli_real_escape_string($conn, $data->user_id);
    $room_number = mysqli_real_escape_string($conn, $data->room_number);
    $issue = mysqli_real_escape_string($conn, $data->issue);
    $urgency = isset($data->urgency) ? mysqli_real_escape_string($conn, $data->urgency) : 'Normal';

    $sql = "INSERT INTO complaints (user_id, room_number, issue, urgency) VALUES ('$user_id', '$room_number', '$issue', '$urgency')";

    if($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Complaint submitted"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
}
?>