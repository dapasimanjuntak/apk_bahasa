# 📚 APK Bahasa - Dokumentasi Lengkap NLP

> Aplikasi pembelajaran bahasa Indonesia berbasis Flutter + Firebase + NLP dengan sistem evaluasi jawaban otomatis menggunakan AI

**Repository:** dapasimanjuntak/apk_bahasa  
**Bahasa:** Dart (Flutter) 62.8% | HTML 37.2%  
**Status:** 🟡 Development  
**Dibuat:** 2026-03-25

---

## 📖 Daftar Isi

- [Gambaran Umum](#-gambaran-umum)
- [Fitur NLP](#-fitur-nlp)
- [Arsitektur Sistem](#-arsitektur-sistem)
- [Mode Evaluasi](#-mode-evaluasi)
- [Struktur Proyek](#-struktur-proyek)
- [Dependencies](#-dependencies)
- [API Endpoints](#-api-endpoints)
- [Model Data](#-model-data)
- [Panduan Implementasi](#-panduan-implementasi)
- [Troubleshooting](#-troubleshooting)
- [Checklist Production](#-checklist-production-ready)

---

## 🎯 Gambaran Umum

**APK Bahasa** adalah aplikasi pembelajaran bahasa Indonesia interaktif yang mengintegrasikan:

✅ **Kuis Bahasa Dinamis** - Soal dari berbagai skenario (tumbuhan, hewan, umum)  
✅ **Evaluasi Otomatis AI** - Penilaian semantic menggunakan Google Gemini  
✅ **Fallback Offline** - TF-IDF + Cosine Similarity untuk independence  
✅ **Firebase Integration** - Cloud database & authentication  
✅ **Multi-Language** - Bahasa Indonesia & Inggris  
✅ **Progress Tracking** - Simpan skor & pembelajaran ke cloud

**Target User:** Pelajar bahasa Indonesia tingkat pemula hingga menengah

---

## 🧠 Fitur NLP

Aplikasi menggunakan **sistem hybrid** dengan 2 mode evaluasi:

### 1️⃣ Online Mode - Google Gemini (Primary)

**Lokasi:** `lib/services/nlp_quiz_service.dart`

| Aspek | Detail |
|-------|--------|
| **Akurasi** | ⭐⭐⭐⭐⭐ Sangat Tinggi |
| **Teknologi** | Google Gemini API |
| **Endpoint** | `http://206.189.46.79:8080/evaluate` |
| **Timeout** | 15 detik |
| **Evaluasi** | Semantic similarity (makna & konteks) |

**Flow:**
