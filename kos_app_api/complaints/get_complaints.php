<?php
include '../db_connect.php';

// Join tabel agar dapat nama tenant
 $sql = "SELECT c.*, u.name as tenant_name FROM complaints c JOIN users u ON c.user_id = u.id ORDER BY c.created_at DESC";
 $result = $conn->query($sql);
 $complaints = [];

while($row = $result->fetch_assoc()) {
    $complaints[] = $row;
}
echo json_encode($complaints);
?>