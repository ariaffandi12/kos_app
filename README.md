# 🏠 Kos App — Aplikasi Manajemen Kos

Kos App adalah aplikasi mobile untuk membantu pemilik kos dan penghuni dalam mengelola proses sewa kamar, pembayaran tagihan, komplain, hingga komunikasi melalui chat. Dibangun menggunakan Flutter dengan arsitektur modular agar mudah dikembangkan.

---

## ✨ Fitur Utama

- Login & Register
- Role User: Owner & Tenant
- Lihat kamar & status sewa
- Tagihan otomatis setiap tanggal 1
- Reminder pembayaran sampai tanggal 5 (grace period)
- Upload bukti pembayaran
- Status pembayaran: Unpaid, Paid, Late
- Komplain & Manajemen Komplain
- Chat realtime antara Tenant dan Owner

---

## 📂 Struktur Project
kos_app/
├── android/
├── ios/
├── test/
│
├── lib/
│   ├── main.dart
│   │
│   ├── models/
│   │   ├── user.dart
│   │   ├── room.dart
│   │   ├── bill.dart
│   │   ├── complaint.dart
│   │   └── chat.dart
│   │
│   ├── services/
│   │   ├── db_service.dart
│   │   ├── auth_service.dart
│   │   ├── room_service.dart
│   │   ├── billing_service.dart
│   │   ├── complaint_service.dart
│   │   └── chat_service.dart
│   │
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── particle_background.dart
│   │   └── status_badge.dart
│   │
│   └── screens/
│       ├── login.dart
│       ├── register.dart
│       ├── owner_dashboard.dart
│       ├── tenant_dashboard.dart
│       ├── rooms.dart
│       ├── complaints.dart
│       └── chat.dart
│
├── assets/
│   ├── images/
│   └── lottie/
│
└── pubspec.yaml
