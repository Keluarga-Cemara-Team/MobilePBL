# 📱 AntiBurnout - Mobile Application (Flutter)

Aplikasi mobile dan web interaktif untuk pengguna (mahasiswa dan profesional muda) yang menyediakan fitur asesmen kesehatan mental, deteksi dini risiko *burnout* berbasis **Machine Learning**, pelacakan statistik risiko, personalisasi preferensi, serta rekomendasi gaya hidup sehat.

---

## ✨ Fitur Utama
1. **Interactive Survey Stepper**: Kuesioner dinamis 7 pertanyaan gaya hidup dan beban aktivitas dengan validasi real-time.
2. **AI-Powered Burnout Diagnosis**: Terhubung secara langsung dengan microservice Machine Learning melalui WebPBL Backend API (`POST /assessment/api/predict`).
3. **Hasil & Rekomendasi Personal**: Menampilkan level risiko (*Rendah / Sedang / Tinggi*), skor numerik burnout, status kesehatan mental, faktor pemicu utama, dan tips pemulihan AI.
4. **Google Sign-In & Firebase Auth**: Autentikasi modern satu klik via akun Google maupun Email/Password, lengkap dengan sinkronisasi otomatis data profil (`full_name`, `email`, `photo_url`) ke Cloud Firestore.
5. **Cloud Firestore Sync**: Riwayat asesmen dan personalisasi profil tersimpan secara real-time di Google Cloud Firestore.
6. **Dukungan Multi-Platform**: Berjalan mulus di Android, iOS, dan Flutter Web dengan penanganan CORS dan platform-safe HTTP dispatching.

---

## 🏛️ Arsitektur Aplikasi (Riverpod & Clean Architecture)

```text
lib/
├── core/
│   ├── network/             # ApiClient (Platform-safe: web & io)
│   ├── theme/               # Tema Material 3, Warna Risiko, & Tipografi
│   └── utils/               # Formatter tanggal & helper
│
├── features/
│   ├── assessment/          # Modul Hasil Diagnosa & Riwayat Asesmen
│   │   ├── data/            # FirestoreAssessmentRepository & Fixtures
│   │   ├── domain/          # Entity Assessment, RiskLevel, & Use Cases
│   │   └── presentation/    # AssessmentResultPage & AssessmentStatsPage
│   │
│   ├── survey/              # Modul Kuesioner Asesmen
│   │   ├── presentation/    # SurveyStepper, SurveyQuestionPage, SurveyIntroPage
│   │   └── controllers/     # SurveyController (StateNotifier / Riverpod)
│   │
│   ├── auth/                # Autentikasi Pengguna & Firebase Auth
│   ├── home/                # Dashboard Utama & Ringkasan Risiko
│   └── profile/             # Profil Pengguna & Halaman Preferensi
│
└── main.dart                # Entry point aplikasi Flutter
```

---

## 🚀 Cara Menjalankan Aplikasi

### 1. Prasyarat
- Flutter SDK (>= 3.2.0)
- Backend WebPBL aktif di `http://127.0.0.1:5000`
- ML Microservice aktif di `http://127.0.0.1:8000`

### 2. Jalankan di Chrome (Web Mode)
```bash
cd c:\laragon\www\AntiBurnout\MobilePBL\mobile
flutter run -d chrome
```

### 3. Jalankan di Emulator / Perangkat Android
```bash
flutter run -d <device_id>
```

---

## 🔗 Integrasi Backend & Machine Learning
Aplikasi mobile mengirimkan data kuesioner ke:
```http
POST http://127.0.0.1:5000/assessment/api/predict
Content-Type: application/json
```
WebPBL akan memvalidasi, meminta inferensi dari model terbaik **Gaussian Naive Bayes (98.90% Akurasi)** di `MachineLearningPBL`, menyimpan data ke **Google Cloud Firestore**, dan mengembalikan respon evaluasi resmi ke aplikasi mobile.

---

## 🔑 Konfigurasi Firebase Authentication & Google Sign-In

Aplikasi AntiBurnout Mobile terintegrasi penuh dengan **Firebase Authentication** dan **Google Cloud Firestore** (`antiburnout-1c07d`).

### 1. Perbedaan Lingkungan: Web vs Android
| Fitur / Platform | Flutter Web (Chrome) | Android (Device / Emulator) |
| :--- | :---: | :---: |
| **Kebutuhan SHA-1** | ❌ **Tidak Perlu** (Otomatis via Web OAuth Client) | ✅ **Wajib** (Untuk handshake Google Play Services) |
| **File Konfigurasi** | Dikelola via SDK web / Firebase core | `android/app/google-services.json` |
| **Setup Tambahan** | Cukup aktifkan provider Google di Firebase Console | Daftarkan fingerprint SHA-1 & update `google-services.json` |

### 2. Fingerprint Sertifikat Debug Android (Development Keystore)
Jika Anda mengembangkan atau menguji di perangkat Android fisik maupun emulator, sertifikat debug lokal PC Anda telah diinspeksi dengan nilai:

- **Package Name**: `com.example.mobile`
- **Keystore Path**: `C:\Users\Pongo\.android\debug.keystore`
- **Alias**: `AndroidDebugKey`
- **SHA-1**:
  ```text
  98:64:4A:36:D9:D4:23:D2:39:5A:BB:81:2F:94:84:07:1B:3D:11:C7
  ```
- **SHA-256**:
  ```text
  9A:95:6B:CE:B5:09:A2:5E:4D:AA:25:08:A8:42:06:15:BD:79:1A:0D:EC:B5:F9:36:D8:82:89:A0:99:11:63:4F
  ```

### 3. Cara Mendapatkan SHA-1 Baru di PowerShell
Jika Anda berpindah laptop / PC, buka terminal PowerShell dan jalankan:
```powershell
cd android
.\gradlew signingReport
```
*(Wajib menggunakan `.\` di PowerShell agar skrip lokal diizinkan berjalan).*

### 4. Langkah Setup di Firebase Console
1. Buka [Firebase Console - Authentication](https://console.firebase.google.com/project/antiburnout-1c07d/authentication/providers).
2. Di tab **Sign-in method**, pilih **Google**, aktifkan (**Enable**), pilih email support project, lalu klik **Save**.
3. Buka **Project Settings** (ikon gerigi) -> menu **General** -> scroll ke bagian **Your apps** -> pilih `com.example.mobile`.
4. Klik **Add fingerprint** dan masukkan kode **SHA-1** serta **SHA-256** di atas.
5. Unduh file `google-services.json` yang telah diperbarui oleh Firebase, lalu simpan ke folder:
   ```text
   MobilePBL/mobile/android/app/google-services.json
   ```
6. Jalankan aplikasi, tombol **"Masuk dengan Google"** siap digunakan secara instan!
