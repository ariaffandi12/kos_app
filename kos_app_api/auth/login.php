<?php
include '../db_connect.php';
 $data = json_decode(file_get_contents("php://input"));

if(isset($data->email) && isset($data->password)) {
    $email = mysqli_real_escape_string($conn, $data->email);
    $pass = mysqli_real_escape_string($conn, $data->password);

    $sql = "SELECT * FROM users WHERE email='$email' AND password='$pass'";
    $result = $conn->query($sql);

    if($result->num_rows > 0) {
        echo json_encode(["status" => "success", "data" => $result->fetch_assoc()]);
    } else {
        echo json_encode(["status" => "fail", "message" => "Invalid Credentials"]);
    }
}
?>