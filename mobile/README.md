# 📱 AntiBurnout - Mobile Application (Flutter)

Aplikasi mobile dan web interaktif untuk pengguna (mahasiswa dan profesional muda) yang menyediakan fitur asesmen kesehatan mental, deteksi dini risiko *burnout* berbasis **Machine Learning**, pelacakan statistik risiko, personalisasi preferensi, serta rekomendasi gaya hidup sehat.

---

## ✨ Fitur Utama
1. **Interactive Survey Stepper**: Kuesioner dinamis 7 pertanyaan gaya hidup dan beban aktivitas dengan validasi real-time.
2. **AI-Powered Burnout Diagnosis**: Terhubung secara langsung dengan microservice Machine Learning melalui WebPBL Backend API (`POST /assessment/api/predict`).
3. **Hasil & Rekomendasi Personal**: Menampilkan level risiko (*Rendah / Sedang / Tinggi*), skor numerik burnout, status kesehatan mental, faktor pemicu utama, dan tips pemulihan AI.
4. **Cloud Firestore Sync**: Riwayat asesmen dan personalisasi profil tersimpan secara real-time di Google Cloud Firestore.
5. **Dukungan Multi-Platform**: Berjalan mulus di Android, iOS, dan Flutter Web dengan penanganan CORS dan platform-safe HTTP dispatching.

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
