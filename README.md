# kos_app

kos_app/                          <-- Root Project (Folder Utama)
│
├── android/                       <-- (Otomatis dibuat Flutter)
├── ios/                           <-- (Otomatis dibuat Flutter)
├── test/                          <-- (Otomatis dibuat Flutter)
│
├── lib/                           <-- Folder kode utama (Focus disini)
│   ├── main.dart                  <-- Entry point aplikasi
│   │
│   ├── models/                    <-- Folder untuk Model Data
│   │   ├── user.dart
│   │   ├── room.dart
│   │   ├── bill.dart
│   │   ├── complaint.dart
│   │   └── chat.dart
│   │
│   ├── services/                  <-- Folder untuk Logic & Database
│   │   ├── db_service.dart
│   │   ├── auth_service.dart
│   │   ├── room_service.dart
│   │   ├── billing_service.dart
│   │   ├── complaint_service.dart
│   │   └── chat_service.dart
│   │
│   ├── widgets/                   <-- Folder untuk Komponen UI Reusable
│   │   ├── custom_button.dart
│   │   ├── particle_background.dart
│   │   └── status_badge.dart
│   │
│   └── screens/                   <-- Folder untuk Halaman (Page)
│       ├── login.dart
│       ├── register.dart
│       ├── owner_dashboard.dart
│       ├── tenant_dashboard.dart
│       ├── rooms.dart
│       ├── complaints.dart
│       └── chat.dart
│
├── assets/                        <-- Folder Asset (Anda harus buat manual ini)
│   ├── images/                    <-- Tempat simpan foto upload/user
│   └── lottie/                     <-- Tempat simpan file animasi .json
│
└── pubspec.yaml                   <-- File konfigurasi (Diupdate sesuai kode di atas)
