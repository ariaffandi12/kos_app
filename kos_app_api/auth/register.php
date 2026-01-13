<?php
include '../db_connect.php';
 $data = json_decode(file_get_contents("php://input"));

if(isset($data->name) && isset($data->email) && isset($data->password) && isset($data->role)) {
    $name = mysqli_real_escape_string($conn, $data->name);
    $email = mysqli_real_escape_string($conn, $data->email);
    $pass = mysqli_real_escape_string($conn, $data->password);
    $role = mysqli_real_escape_string($conn, $data->role);

    // Cek email duplikat
    $checkEmail = $conn->query("SELECT id FROM users WHERE email='$email'");
    if($checkEmail->num_rows > 0){
        echo json_encode(["status" => "fail", "message" => "Email already registered"]);
    } else {
        $sql = "INSERT INTO users (name, email, password, role) VALUES ('$name', '$email', '$pass', '$role')";
        if($conn->query($sql) === TRUE) {
            echo json_encode(["status" => "success", "message" => "User registered successfully"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Registration failed"]);
        }
    }
}
?>