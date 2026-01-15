# Averroes — Product Context

## 1. Overview
**Averroes** adalah aplikasi mobile pendamping keuangan & edukasi Islam modern untuk Gen Z Muslim Indonesia.  
Fokus utama aplikasi ini adalah **crypto syariah, fiqh muamalah, zakat, dan refleksi spiritual**, dengan pendekatan **human, personal, dan tidak menggurui**.

Averroes bukan aplikasi institusi.  
Averroes adalah **teman pintar yang menemani keseharian**.

---

## 2. Target User
**Primary:**  
- Gen Z Muslim Indonesia (18–28 tahun)
- Melek digital & crypto
- Ingin belajar fiqh muamalah secara ringan & relevan
- Tidak suka UI kaku, formal, atau “terlalu ustadz”

**Secondary:**  
- Muslim muda non-crypto (edukasi & pustaka)
- Mahasiswa & early professional

---

## 3. Product Positioning
❌ Bukan:
- Dashboard fitur
- Aplikasi bank
- Aplikasi fatwa kaku
- UI template AI

✅ Tapi:
- Daily Islamic financial companion
- Edukatif + reflektif
- Modern, santun, dan relevan
- Calm, friendly, quietly confident

---

## 4. Core Principles (Non-Negotiable)

### 4.1 UX Philosophy
- **Story-driven, not feature-driven**
- **Content > Icon**
- **Context > Menu**
- **Human imperfection over perfect symmetry**

### 4.2 Gen Z Design Rules
- Conversational copywriting (bukan instruktif)
- Micro-interactions kecil (haptic, subtle animation)
- Tidak berisik, tidak norak
- UI terasa “dipilih”, bukan “digenerate”

---

## 5. App Architecture (High Level)

### Tech Stack
- **Flutter** (Mobile)
- **GetX** (State & Navigation)
- **Supabase**
  - Auth (email/password + guest)
  - Database (portfolio, progress, bookmarks)
- **External APIs**
  - CoinGecko → harga crypto realtime
  - Google News RSS → berita crypto
  - MyQuran / Quran API → ayat & audio

---

## 6. Authentication Rules
- Login dengan **email & password**
- **Email verification wajib**
- Mode **Guest**
  - Read-only
  - Tidak bisa CRUD portofolio / zakat
  - Soft prompt untuk login
- Tidak ada login wallet (manual input portfolio)

---

## 7. Core Features (Final & Fixed)

### 7.1 Home (Beranda)
Home adalah **narasi harian**, bukan menu.

Urutan:
1. Greeting personal
2. Waktu sholat (2 card: Jakarta & Mekkah, no overflow)
3. Hero card (1 fokus utama)
4. **Berita Terkini (5 item)**  
   - Tombol “Lihat Semua” → page berita (15–20 item)
5. Refleksi (ayat/hadits/fiqh quote)
6. Quick actions (max 3)

⚠️ Tidak boleh ada grid menu besar di Home.

---

### 7.2 Screener Crypto Syariah
- Data tetap dipertahankan
- Kategori **“Syubhat” diganti “Proses”**
- Popup notice **muncul setiap buka screener**
- UI informatif, tidak agresif
- Fokus ke kejelasan & kepercayaan

---

### 7.3 Pasar
- Harga crypto realtime (CoinGecko)
- UI harus harmonis dengan Home (tidak beda gaya)
- Klik coin → detail & chart

---

### 7.4 Portofolio
- Manual input asset
- CRUD via Supabase (RLS aktif)
- Harga realtime CoinGecko
- Total aset & estimasi zakat
- Mode guest = read-only dummy data

---

### 7.5 Zakat
- Estimasi zakat dari total portofolio
- Read-only (tidak ada transaksi)
- Tone serius & trustworthy

---

### 7.6 Edukasi
- Model **kelas**
- Bisa buka detail kelas
- Progress belajar
- Copywriting ringan & membumi

---

### 7.7 Pustaka
- E-library (kitab & buku)
- Judul readable + metadata asli disimpan
- UI seperti reading app (bukan marketplace)

---

### 7.8 Reels (Hikmah)
- Konten ayat / hadits / fiqh muamalah / takdir
- Audio & teks **harus sinkron**
- Tidak terasa TikTok
- Calm, reflective, Instagram-story vibe

---

### 7.9 Chatbot
- Pretrained model
- Scope dibatasi:
  - Crypto syariah
  - Fiqh muamalah
  - Zakat
- Bukan general AI

---

## 8. UI Guidelines (Anti AI-Look)

### Layout
- Hindari grid seragam
- Asimetri terkontrol
- Campur card besar & kecil

### Typography
- Primary: Plus Jakarta Sans / Manrope / Satoshi
- Arabic: Amiri / IBM Plex Arabic
- Hierarki jelas

### Color
- Earthy, soft, muted
- Hindari neon & gradient berlebihan
- Off-white background

---

## 9. Copywriting Tone
- Islami
- Santun
- Friendly
- Tidak menggurui
- Tidak “marketing berisik”

Contoh:
- “Lanjut dikit yuk ✨”
- “Lagi rame nih 🔥”
- “Nanya ustadz?”

---

## 10. Non-Goals
- Tidak mengejar “wah”
- Tidak mengejar semua fitur
- Tidak jadi super app
- Tidak terlihat seperti AI template

---

## 11. Success Metric (UX)
Jika user berkata:
> “Enak ya pakenya”

Itu sukses.  
Bukan:
> “Wah rapi”

---

## 12. Final Note
Averroes harus terasa **dipikirkan oleh manusia**,  
bukan **dibangun oleh AI**.

Semua keputusan UI/UX harus bisa dijawab dengan:
> “Apakah ini bikin user merasa ditemani?”

Jika tidak → redesign.
