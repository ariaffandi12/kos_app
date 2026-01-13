-- 1. Hapus Database Lama Jika Ada (Opsional, biar bersih)
DROP DATABASE IF EXISTS kos_db;

-- 2. Buat Database Baru
CREATE DATABASE kos_db;
USE kos_db;

-- 3. Tabel Users (Untuk Login)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Tenant', 'Owner') NOT NULL,
    room_id INT NULL
);

-- 4. Tabel Rooms (Untuk Kamar)
CREATE TABLE IF NOT EXISTS rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(20),
    type VARCHAR(50),
    price DECIMAL(10, 2),
    status ENUM('Available', 'Occupied', 'Maintenance') DEFAULT 'Available',
    image_url VARCHAR(255),
    tenant_name VARCHAR(100) NULL
);

-- 5. Tabel Bills (Untuk Tagihan)
CREATE TABLE IF NOT EXISTS bills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    month VARCHAR(50),
    total_amount DECIMAL(10, 2),
    status ENUM('Unpaid', 'Pending', 'Paid') DEFAULT 'Unpaid',
    proof_image VARCHAR(255) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 6. Tabel Complaints (Untuk Keluhan)
CREATE TABLE IF NOT EXISTS complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    room_number VARCHAR(20),
    issue TEXT,
    urgency ENUM('Normal', 'Urgent') DEFAULT 'Normal',
    status ENUM('Open', 'In Progress', 'Resolved') DEFAULT 'Open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 7. Tabel Announcements (Untuk Pengumuman)
CREATE TABLE IF NOT EXISTS announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. MASUKKAN DATA DUMMY (AGAR APLIKASI LANGSUNG BISA TES)
INSERT INTO users (name, email, password, role, room_id) VALUES 
('Owner Demo', 'owner@kos.com', '123', 'Owner', NULL),
('Alex Thompson', 'tenant@kos.com', '123', 'Tenant', 204);

INSERT INTO rooms (room_number, type, price, status, tenant_name) VALUES 
('101', 'Standard', 1500000, 'Occupied', 'John Doe'),
('102', 'Deluxe', 1750000, 'Available', NULL),
('201', 'Standard', 1500000, 'Available', NULL),
('202', 'Standard', 1600000, 'Maintenance', 'AC Repair'),
('204', 'Premium', 535.50, 'Occupied', 'Alex Thompson'),
('301', 'Premium', 2000000, 'Occupied', 'Sarah Miller');

INSERT INTO bills (user_id, month, total_amount, status) VALUES
(2, 'October 2023', 535.50, 'Unpaid');

INSERT INTO complaints (user_id, room_number, issue, urgency, status) VALUES
(1, '204', 'AC Leaking & Noise', 'Urgent', 'In Progress'),
(3, '102', 'Light Bulb Dead', 'Normal', 'Resolved'),
(3, '305', 'Door Handle Loose', 'Normal', 'Open');

INSERT INTO announcements (title, content) VALUES 
('Wi-Fi Maintenance', 'System upgrade scheduled for Friday at 2:00 AM.'),
('New Laundry Rules', 'Please collect your laundry within 30 minutes.');