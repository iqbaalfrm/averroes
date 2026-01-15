import 'edukasi_models.dart';

List<ClassModel> edukasiDummyClasses() {
  final dasarCrypto = ClassModel(
    id: 'class_crypto_dasar',
    title: 'Dasar Crypto Syariah',
    subtitle: 'Kenalan dari nol, biar aman melangkah',
    level: 'Pemula',
    duration: '2 Jam',
    lessonsCount: 8,
    progress: 0.0,
    tags: ['Baru', 'Rekomendasi'],
    coverTheme: CoverTheme.forest,
    description:
        'Mulai dari istilah, cara kerja, sampai cara baca market yang tetap selaras syariah.',
    outcomes: [
      'Ngerti istilah dasar crypto',
      'Paham beda halal, haram, dan syubhat proses',
      'Bisa baca market secara basic',
    ],
    isLocal: true,
    modules: [
      ModuleModel(
        id: 'mod_dasar_1',
        title: 'Peta Dasar Crypto',
        lessons: [
          LessonModel(
            id: 'lesson_dasar_1',
            title: 'Crypto itu apa sih?',
            type: LessonType.reading,
            durationMin: 8,
            summary: 'Gambaran besar tentang aset digital dan kenapa ramai.',
          ),
          LessonModel(
            id: 'lesson_dasar_2',
            title: 'Istilah yang wajib kenal',
            type: LessonType.reading,
            durationMin: 10,
            summary: 'Wallet, exchange, gas fee, dan teman-temannya.',
          ),
          LessonModel(
            id: 'lesson_dasar_3',
            title: 'Beda halal, haram, syubhat',
            type: LessonType.video,
            durationMin: 12,
            summary: 'Pahami prosesnya sebelum ikut-ikutan.',
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_dasar_2',
        title: 'Cara Baca Market Basic',
        lessons: [
          LessonModel(
            id: 'lesson_dasar_4',
            title: 'Harga naik turun itu normal',
            type: LessonType.reading,
            durationMin: 7,
            summary: 'Kenali volatilitas tanpa panik.',
          ),
          LessonModel(
            id: 'lesson_dasar_5',
            title: 'Candlestick ringan',
            type: LessonType.video,
            durationMin: 11,
            summary: 'Baca pola sederhana untuk pemula.',
          ),
          LessonModel(
            id: 'lesson_dasar_6',
            title: 'Checklist sebelum beli',
            type: LessonType.audio,
            durationMin: 6,
            summary: 'Langkah kecil biar lebih aman.',
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_dasar_3',
        title: 'Akhiri dengan Aksi',
        lessons: [
          LessonModel(
            id: 'lesson_dasar_7',
            title: 'Latihan mini: simulasi beli',
            type: LessonType.reading,
            durationMin: 9,
            summary: 'Simulasi tanpa rasa takut.',
          ),
          LessonModel(
            id: 'lesson_dasar_8',
            title: 'Refleksi & catatan pribadi',
            type: LessonType.reading,
            durationMin: 6,
            summary: 'Biar makin mantap melangkah.',
          ),
        ],
      ),
    ],
  );

  final fiqhMuamalah = ClassModel(
    id: 'class_fiqh_muamalah',
    title: 'Fiqh Muamalah untuk Aset Digital',
    subtitle: 'Prinsip syariah biar transaksi lebih tenang',
    level: 'Menengah',
    duration: '3 Jam',
    lessonsCount: 10,
    progress: 0.45,
    tags: ['Menengah', 'Populer'],
    coverTheme: CoverTheme.sand,
    description:
        'Menguatkan landasan fiqh muamalah untuk memahami transaksi aset digital.',
    outcomes: [
      'Memahami kaidah muamalah utama',
      'Bisa membedakan akad yang sah',
      'Lebih yakin saat mengambil keputusan',
    ],
    isLocal: true,
    modules: [
      ModuleModel(
        id: 'mod_fiqh_1',
        title: 'Pijakan Fiqh',
        lessons: [
          LessonModel(
            id: 'lesson_fiqh_1',
            title: 'Muamalah itu luas',
            type: LessonType.reading,
            durationMin: 9,
            summary: 'Apa saja yang masuk ranah muamalah.',
            isCompleted: true,
          ),
          LessonModel(
            id: 'lesson_fiqh_2',
            title: 'Akad dan niat',
            type: LessonType.video,
            durationMin: 13,
            summary: 'Struktur akad dalam transaksi modern.',
            isCompleted: true,
          ),
          LessonModel(
            id: 'lesson_fiqh_3',
            title: 'Riba, gharar, maysir',
            type: LessonType.reading,
            durationMin: 11,
            summary: 'Tiga hal yang wajib dihindari.',
            isCompleted: false,
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_fiqh_2',
        title: 'Aplikasi ke Aset Digital',
        lessons: [
          LessonModel(
            id: 'lesson_fiqh_4',
            title: 'Studi kasus token',
            type: LessonType.video,
            durationMin: 10,
            summary: 'Melihat contoh nyata di lapangan.',
          ),
          LessonModel(
            id: 'lesson_fiqh_5',
            title: 'Kapan dianggap spekulasi',
            type: LessonType.reading,
            durationMin: 8,
            summary: 'Batas halus antara investasi dan judi.',
          ),
          LessonModel(
            id: 'lesson_fiqh_6',
            title: 'Checklist syariah sebelum entry',
            type: LessonType.audio,
            durationMin: 6,
            summary: 'Checklist ringkas biar lebih yakin.',
          ),
          LessonModel(
            id: 'lesson_fiqh_7',
            title: 'Tanya ahli: kasus nyata',
            type: LessonType.video,
            durationMin: 12,
            summary: 'Belajar dari pertanyaan komunitas.',
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_fiqh_3',
        title: 'Merapikan Langkah',
        lessons: [
          LessonModel(
            id: 'lesson_fiqh_8',
            title: 'Ringkasan poin penting',
            type: LessonType.reading,
            durationMin: 7,
            summary: 'Catatan kecil sebelum lanjut.',
          ),
          LessonModel(
            id: 'lesson_fiqh_9',
            title: 'Latihan keputusan',
            type: LessonType.reading,
            durationMin: 8,
            summary: 'Simulasi biar makin mantap.',
          ),
          LessonModel(
            id: 'lesson_fiqh_10',
            title: 'Doa dan adab investor',
            type: LessonType.audio,
            durationMin: 5,
            summary: 'Mindset yang menenangkan.',
          ),
        ],
      ),
    ],
  );

  final zakatAset = ClassModel(
    id: 'class_zakat_aset',
    title: 'Zakat Aset Digital',
    subtitle: 'Bersihkan harta, tenangkan jiwa',
    level: 'Pemula',
    duration: '1.5 Jam',
    lessonsCount: 6,
    progress: 0.0,
    tags: ['Praktis'],
    coverTheme: CoverTheme.sea,
    description:
        'Panduan praktis menghitung dan menunaikan zakat untuk aset digital.',
    outcomes: [
      'Paham kapan wajib zakat',
      'Bisa hitung nisab aset digital',
      'Siap menunaikan dengan yakin',
    ],
    isLocal: true,
    modules: [
      ModuleModel(
        id: 'mod_zakat_1',
        title: 'Niat dan Dasar',
        lessons: [
          LessonModel(
            id: 'lesson_zakat_1',
            title: 'Kenapa zakat itu wajib',
            type: LessonType.reading,
            durationMin: 8,
            summary: 'Tujuan zakat untuk jiwa dan harta.',
          ),
          LessonModel(
            id: 'lesson_zakat_2',
            title: 'Jenis zakat terkait aset digital',
            type: LessonType.video,
            durationMin: 10,
            summary: 'Zakat mal dan konteks baru.',
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_zakat_2',
        title: 'Hitung dan Tunaikan',
        lessons: [
          LessonModel(
            id: 'lesson_zakat_3',
            title: 'Cara hitung nisab',
            type: LessonType.reading,
            durationMin: 9,
            summary: 'Langkah demi langkah yang simpel.',
          ),
          LessonModel(
            id: 'lesson_zakat_4',
            title: 'Simulasi perhitungan',
            type: LessonType.video,
            durationMin: 11,
            summary: 'Contoh angka nyata biar paham.',
          ),
          LessonModel(
            id: 'lesson_zakat_5',
            title: 'Waktu terbaik menunaikan',
            type: LessonType.audio,
            durationMin: 6,
            summary: 'Biar terasa ringan dan tepat.',
          ),
          LessonModel(
            id: 'lesson_zakat_6',
            title: 'Checklist sebelum transfer',
            type: LessonType.reading,
            durationMin: 5,
            summary: 'Supaya nggak kelewat.',
          ),
        ],
      ),
    ],
  );

  final ghararMaisir = ClassModel(
    id: 'class_gharar_maisir',
    title: 'Menghindari Gharar & Maisir dalam Trading',
    subtitle: 'Biar trading tetap aman dan jelas',
    level: 'Menengah',
    duration: '2.5 Jam',
    lessonsCount: 9,
    progress: 0.0,
    tags: ['Wajib Tahu'],
    coverTheme: CoverTheme.clay,
    description:
        'Bedah risiko gharar dan maisir agar trading lebih terarah.',
    outcomes: [
      'Paham bentuk gharar di market',
      'Bisa membedakan trading dan spekulasi',
      'Memiliki batasan pribadi yang jelas',
    ],
    isLocal: true,
    modules: [
      ModuleModel(
        id: 'mod_gharar_1',
        title: 'Mengenali Risiko',
        lessons: [
          LessonModel(
            id: 'lesson_gharar_1',
            title: 'Apa itu gharar?',
            type: LessonType.reading,
            durationMin: 9,
            summary: 'Definisi dan contoh sehari-hari.',
          ),
          LessonModel(
            id: 'lesson_gharar_2',
            title: 'Apa itu maisir?',
            type: LessonType.video,
            durationMin: 12,
            summary: 'Mengapa spekulasi berbahaya.',
          ),
          LessonModel(
            id: 'lesson_gharar_3',
            title: 'Tanda-tanda pasar berisiko',
            type: LessonType.reading,
            durationMin: 8,
            summary: 'Kenali indikator sederhana.',
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_gharar_2',
        title: 'Strategi Aman',
        lessons: [
          LessonModel(
            id: 'lesson_gharar_4',
            title: 'Batasan entry yang sehat',
            type: LessonType.reading,
            durationMin: 10,
            summary: 'Biar tetap terukur.',
          ),
          LessonModel(
            id: 'lesson_gharar_5',
            title: 'Contoh kasus trading',
            type: LessonType.video,
            durationMin: 12,
            summary: 'Belajar dari skenario nyata.',
          ),
          LessonModel(
            id: 'lesson_gharar_6',
            title: 'Checklist sebelum buy',
            type: LessonType.audio,
            durationMin: 6,
            summary: 'Ringkas dan mudah dipakai.',
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_gharar_3',
        title: 'Refleksi & Komitmen',
        lessons: [
          LessonModel(
            id: 'lesson_gharar_7',
            title: 'Latihan menyusun batasan',
            type: LessonType.reading,
            durationMin: 9,
            summary: 'Bangun SOP sederhana.',
          ),
          LessonModel(
            id: 'lesson_gharar_8',
            title: 'Evaluasi diri',
            type: LessonType.reading,
            durationMin: 7,
            summary: 'Menjaga niat tetap lurus.',
          ),
          LessonModel(
            id: 'lesson_gharar_9',
            title: 'Doa penutup',
            type: LessonType.audio,
            durationMin: 4,
            summary: 'Menutup dengan tenang.',
          ),
        ],
      ),
    ],
  );

  final auditSmartContract = ClassModel(
    id: 'class_audit',
    title: 'Audit Smart Contract (Konsep Syariah)',
    subtitle: 'Belajar menilai kontrak dengan kacamata syariah',
    level: 'Mahir',
    duration: '4 Jam',
    lessonsCount: 12,
    progress: 0.0,
    tags: ['Lanjutan'],
    coverTheme: CoverTheme.dusk,
    description:
        'Memahami konsep audit smart contract dan relevansinya dalam muamalah.',
    outcomes: [
      'Paham alur audit smart contract',
      'Bisa membaca potensi pelanggaran syariah',
      'Siap berdiskusi dengan tim teknis',
    ],
    isLocal: true,
    modules: [
      ModuleModel(
        id: 'mod_audit_1',
        title: 'Fondasi Teknis',
        lessons: [
          LessonModel(
            id: 'lesson_audit_1',
            title: 'Smart contract 101',
            type: LessonType.reading,
            durationMin: 12,
            summary: 'Struktur kontrak digital modern.',
          ),
          LessonModel(
            id: 'lesson_audit_2',
            title: 'Risiko yang sering muncul',
            type: LessonType.video,
            durationMin: 15,
            summary: 'Bug, celah, dan potensi pelanggaran.',
          ),
          LessonModel(
            id: 'lesson_audit_3',
            title: 'Mapping ke prinsip syariah',
            type: LessonType.reading,
            durationMin: 11,
            summary: 'Mencari titik kritis sesuai muamalah.',
          ),
          LessonModel(
            id: 'lesson_audit_4',
            title: 'Checklist audit ringkas',
            type: LessonType.audio,
            durationMin: 8,
            summary: 'Checklist sebelum kamu review.',
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_audit_2',
        title: 'Studi Kasus',
        lessons: [
          LessonModel(
            id: 'lesson_audit_5',
            title: 'Kasus token utilitas',
            type: LessonType.video,
            durationMin: 12,
            summary: 'Membedah satu proyek nyata.',
          ),
          LessonModel(
            id: 'lesson_audit_6',
            title: 'Kasus DeFi sederhana',
            type: LessonType.reading,
            durationMin: 10,
            summary: 'Kapan skema mulai riskan.',
          ),
          LessonModel(
            id: 'lesson_audit_7',
            title: 'Latihan review singkat',
            type: LessonType.reading,
            durationMin: 9,
            summary: 'Latihan biar makin paham.',
          ),
          LessonModel(
            id: 'lesson_audit_8',
            title: 'Tanya jawab ahli',
            type: LessonType.audio,
            durationMin: 7,
            summary: 'Menjawab pertanyaan umum.',
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_audit_3',
        title: 'Standar Pribadi',
        lessons: [
          LessonModel(
            id: 'lesson_audit_9',
            title: 'Menyusun SOP audit',
            type: LessonType.reading,
            durationMin: 12,
            summary: 'Biar prosesnya konsisten.',
          ),
          LessonModel(
            id: 'lesson_audit_10',
            title: 'Kolaborasi dengan tim',
            type: LessonType.video,
            durationMin: 10,
            summary: 'Bekerja bareng tim teknis.',
          ),
          LessonModel(
            id: 'lesson_audit_11',
            title: 'Menutup audit dengan rekomendasi',
            type: LessonType.reading,
            durationMin: 9,
            summary: 'Cara menyampaikan hasil.',
          ),
          LessonModel(
            id: 'lesson_audit_12',
            title: 'Refleksi akhir',
            type: LessonType.audio,
            durationMin: 5,
            summary: 'Meneguhkan niat dan tujuan.',
          ),
        ],
      ),
    ],
  );

  final mindsetQanaah = ClassModel(
    id: 'class_qanaah',
    title: "Mindset Qana'ah & Sabar di Dunia Investasi",
    subtitle: 'Tenang dulu, biar langkah makin sadar',
    level: 'Pemula',
    duration: '1 Jam',
    lessonsCount: 5,
    progress: 0.0,
    tags: ['Psikologi', 'Refleksi'],
    coverTheme: CoverTheme.berry,
    description:
        'Menguatkan mental investasi dengan nilai qanaah dan sabar.',
    outcomes: [
      'Lebih tahan FOMO',
      'Paham makna qanaah dalam investasi',
      'Bisa menjaga emosi tetap stabil',
    ],
    isLocal: true,
    modules: [
      ModuleModel(
        id: 'mod_qanaah_1',
        title: 'Menenangkan Diri',
        lessons: [
          LessonModel(
            id: 'lesson_qanaah_1',
            title: 'Kenapa kita mudah panik',
            type: LessonType.reading,
            durationMin: 8,
            summary: 'Memahami pola emosi saat market turun.',
          ),
          LessonModel(
            id: 'lesson_qanaah_2',
            title: 'Makna qanaah',
            type: LessonType.audio,
            durationMin: 7,
            summary: 'Qanaah bukan pasrah, tapi sadar.',
          ),
        ],
      ),
      ModuleModel(
        id: 'mod_qanaah_2',
        title: 'Menata Ulang Target',
        lessons: [
          LessonModel(
            id: 'lesson_qanaah_3',
            title: 'Target realistis',
            type: LessonType.reading,
            durationMin: 9,
            summary: 'Menetapkan target yang sehat.',
          ),
          LessonModel(
            id: 'lesson_qanaah_4',
            title: 'Latihan sabar 5 menit',
            type: LessonType.video,
            durationMin: 6,
            summary: 'Latihan kecil untuk menenangkan diri.',
          ),
          LessonModel(
            id: 'lesson_qanaah_5',
            title: 'Catatan syukur',
            type: LessonType.reading,
            durationMin: 5,
            summary: 'Menutup dengan rasa syukur.',
          ),
        ],
      ),
    ],
  );

  return [
    dasarCrypto,
    fiqhMuamalah,
    zakatAset,
    ghararMaisir,
    auditSmartContract,
    mindsetQanaah,
  ];
}
