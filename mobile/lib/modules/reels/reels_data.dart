/// =============================================================================
/// REELS DATA - Dummy Data untuk Konten Hikmah Islami
/// =============================================================================
/// Konten mikro: Ayat, Hadits, dan Quote tentang Fikih Muamalah, Takdir, Sabar, Qonaah
/// 
/// DISCLAIMER: Konten ini untuk edukasi. Referensi hadits yang kurang kuat
/// ditandai sebagai "riwayat masyhur" untuk transparansi.
/// =============================================================================

import 'package:flutter/material.dart';

/// Kategori konten
enum ReelCategory {
  semua,
  fiqhMuamalah,
  takdir,
  sabar,
  qonaah,
}

extension ReelCategoryExtension on ReelCategory {
  String get label {
    switch (this) {
      case ReelCategory.semua:
        return 'Semua';
      case ReelCategory.fiqhMuamalah:
        return 'Fikih Muamalah';
      case ReelCategory.takdir:
        return 'Takdir';
      case ReelCategory.sabar:
        return 'Sabar';
      case ReelCategory.qonaah:
        return 'Qonaah';
    }
  }

  Color get color {
    switch (this) {
      case ReelCategory.semua:
        return const Color(0xFF10B981);
      case ReelCategory.fiqhMuamalah:
        return const Color(0xFF6366F1);
      case ReelCategory.takdir:
        return const Color(0xFFEC4899);
      case ReelCategory.sabar:
        return const Color(0xFF14B8A6);
      case ReelCategory.qonaah:
        return const Color(0xFFF59E0B);
    }
  }

  List<Color> get gradient {
    switch (this) {
      case ReelCategory.semua:
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case ReelCategory.fiqhMuamalah:
        return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      case ReelCategory.takdir:
        return [const Color(0xFFEC4899), const Color(0xFFF472B6)];
      case ReelCategory.sabar:
        return [const Color(0xFF14B8A6), const Color(0xFF2DD4BF)];
      case ReelCategory.qonaah:
        return [const Color(0xFFF59E0B), const Color(0xFFFBBF24)];
    }
  }
}

/// Tipe konten
enum ReelType {
  ayat,
  hadith,
  quote,
}

extension ReelTypeExtension on ReelType {
  String get label {
    switch (this) {
      case ReelType.ayat:
        return 'Al-Quran';
      case ReelType.hadith:
        return 'Hadits';
      case ReelType.quote:
        return 'Hikmah';
    }
  }

  IconData get icon {
    switch (this) {
      case ReelType.ayat:
        return Icons.menu_book_rounded;
      case ReelType.hadith:
        return Icons.format_quote_rounded;
      case ReelType.quote:
        return Icons.auto_awesome_rounded;
    }
  }
}

/// Model untuk item Reel
class ReelItem {
  final String id;
  final ReelCategory category;
  final ReelType type;
  final String? arabic;
  final String indonesia;
  final String reflection;
  final String source;
  final List<String> tags;
  final List<Color>? backgroundGradient;
  final bool isHadithStrong; // true jika hadits shahih, false jika dhaif/masyhur

  const ReelItem({
    required this.id,
    required this.category,
    required this.type,
    this.arabic,
    required this.indonesia,
    required this.reflection,
    required this.source,
    this.tags = const [],
    this.backgroundGradient,
    this.isHadithStrong = true,
  });
}

/// =============================================================================
/// DUMMY DATA - 25+ Konten Hikmah
/// =============================================================================

const List<ReelItem> dummyReelsData = [
  // ===== FIQH MUAMALAH =====
  ReelItem(
    id: 'fm001',
    category: ReelCategory.fiqhMuamalah,
    type: ReelType.ayat,
    arabic: 'وَأَحَلَّ اللَّهُ الْبَيْعَ وَحَرَّمَ الرِّبَا',
    indonesia: 'Dan Allah telah menghalalkan jual beli dan mengharamkan riba.',
    reflection: 'Islam mendorong aktivitas ekonomi yang halal dan melarang eksploitasi melalui riba.',
    source: 'QS. Al-Baqarah: 275',
    tags: ['riba', 'jual-beli', 'halal'],
  ),
  ReelItem(
    id: 'fm002',
    category: ReelCategory.fiqhMuamalah,
    type: ReelType.hadith,
    arabic: 'الْبَيِّعَانِ بِالْخِيَارِ مَا لَمْ يَتَفَرَّقَا',
    indonesia: 'Penjual dan pembeli memiliki hak khiyar (memilih) selama keduanya belum berpisah.',
    reflection: 'Transparansi dan keadilan adalah fondasi transaksi dalam Islam.',
    source: 'HR. Bukhari & Muslim',
    tags: ['khiyar', 'transaksi', 'jual-beli'],
    isHadithStrong: true,
  ),
  ReelItem(
    id: 'fm003',
    category: ReelCategory.fiqhMuamalah,
    type: ReelType.ayat,
    arabic: 'يَا أَيُّهَا الَّذِينَ آمَنُوا أَوْفُوا بِالْعُقُودِ',
    indonesia: 'Wahai orang-orang yang beriman, penuhilah akad-akad (perjanjian).',
    reflection: 'Menepati janji dan kontrak adalah perintah Allah yang harus dijaga.',
    source: 'QS. Al-Maidah: 1',
    tags: ['akad', 'janji', 'amanah'],
  ),
  ReelItem(
    id: 'fm004',
    category: ReelCategory.fiqhMuamalah,
    type: ReelType.hadith,
    arabic: 'لَا ضَرَرَ وَلَا ضِرَارَ',
    indonesia: 'Tidak boleh membahayakan diri sendiri dan tidak boleh membahayakan orang lain.',
    reflection: 'Prinsip dasar muamalah: tidak ada pihak yang dirugikan.',
    source: 'HR. Ibnu Majah & Ahmad',
    tags: ['dharar', 'keadilan', 'prinsip'],
    isHadithStrong: true,
  ),
  ReelItem(
    id: 'fm005',
    category: ReelCategory.fiqhMuamalah,
    type: ReelType.quote,
    indonesia: 'Pedagang yang jujur dan amanah akan bersama para Nabi, shiddiqin, dan syuhada.',
    reflection: 'Kejujuran dalam bisnis adalah jalan menuju surga.',
    source: 'Hikmah dari HR. Tirmidzi',
    tags: ['jujur', 'amanah', 'pedagang'],
  ),
  ReelItem(
    id: 'fm006',
    category: ReelCategory.fiqhMuamalah,
    type: ReelType.ayat,
    arabic: 'وَلَا تَأْكُلُوا أَمْوَالَكُمْ بَيْنَكُمْ بِالْبَاطِلِ',
    indonesia: 'Dan janganlah kamu memakan harta di antara kamu dengan cara yang batil.',
    reflection: 'Setiap transaksi harus berbasis kerelaan dan kehalalan.',
    source: 'QS. An-Nisa: 29',
    tags: ['batil', 'halal', 'harta'],
  ),

  // ===== TAKDIR =====
  ReelItem(
    id: 'tk001',
    category: ReelCategory.takdir,
    type: ReelType.ayat,
    arabic: 'قُلْ لَنْ يُصِيبَنَا إِلَّا مَا كَتَبَ اللَّهُ لَنَا',
    indonesia: 'Katakanlah: Tidak akan menimpa kami kecuali apa yang telah Allah tetapkan bagi kami.',
    reflection: 'Beriman kepada takdir memberikan ketenangan hati di setiap situasi.',
    source: 'QS. At-Taubah: 51',
    tags: ['takdir', 'iman', 'ketenangan'],
  ),
  ReelItem(
    id: 'tk002',
    category: ReelCategory.takdir,
    type: ReelType.hadith,
    arabic: 'وَاعْلَمْ أَنَّ مَا أَصَابَكَ لَمْ يَكُنْ لِيُخْطِئَكَ',
    indonesia: 'Ketahuilah bahwa apa yang menimpamu tidak akan luput darimu.',
    reflection: 'Segala yang terjadi sudah ditakdirkan dengan hikmah yang sempurna.',
    source: 'HR. Ahmad & Tirmidzi',
    tags: ['takdir', 'qadha', 'hikmah'],
    isHadithStrong: true,
  ),
  ReelItem(
    id: 'tk003',
    category: ReelCategory.takdir,
    type: ReelType.quote,
    indonesia: 'Jika Allah tidak mengabulkan doamu, bukan berarti Dia tidak mendengar. Boleh jadi Dia sedang menyiapkan yang lebih baik.',
    reflection: 'Percaya pada rencana Allah adalah bentuk husnuzhon tertinggi.',
    source: 'Hikmah Ulama',
    tags: ['doa', 'husnuzhon', 'sabar'],
  ),
  ReelItem(
    id: 'tk004',
    category: ReelCategory.takdir,
    type: ReelType.ayat,
    arabic: 'وَعَسَىٰ أَنْ تَكْرَهُوا شَيْئًا وَهُوَ خَيْرٌ لَكُمْ',
    indonesia: 'Boleh jadi kamu membenci sesuatu padahal ia baik bagimu.',
    reflection: 'Tidak selamanya yang kita inginkan adalah yang terbaik untuk kita.',
    source: 'QS. Al-Baqarah: 216',
    tags: ['takdir', 'hikmah', 'kebaikan'],
  ),
  ReelItem(
    id: 'tk005',
    category: ReelCategory.takdir,
    type: ReelType.hadith,
    indonesia: 'Sungguh menakjubkan urusan seorang mukmin. Semua urusannya adalah baik baginya.',
    reflection: 'Bersyukur saat senang dan bersabar saat susah - keduanya adalah kebaikan.',
    source: 'HR. Muslim',
    tags: ['mukmin', 'syukur', 'sabar'],
    isHadithStrong: true,
  ),

  // ===== SABAR =====
  ReelItem(
    id: 'sb001',
    category: ReelCategory.sabar,
    type: ReelType.ayat,
    arabic: 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
    indonesia: 'Sesungguhnya Allah bersama orang-orang yang sabar.',
    reflection: 'Kesabaran menghadirkan kebersamaan dengan Allah.',
    source: 'QS. Al-Baqarah: 153',
    tags: ['sabar', 'kebersamaan', 'Allah'],
  ),
  ReelItem(
    id: 'sb002',
    category: ReelCategory.sabar,
    type: ReelType.ayat,
    arabic: 'وَبَشِّرِ الصَّابِرِينَ',
    indonesia: 'Dan berilah kabar gembira kepada orang-orang yang sabar.',
    reflection: 'Kesabaran akan berbuah kegembiraan yang dijanjikan Allah.',
    source: 'QS. Al-Baqarah: 155',
    tags: ['sabar', 'kabar-gembira', 'janji'],
  ),
  ReelItem(
    id: 'sb003',
    category: ReelCategory.sabar,
    type: ReelType.hadith,
    arabic: 'الصَّبْرُ ضِيَاءٌ',
    indonesia: 'Sabar itu cahaya.',
    reflection: 'Kesabaran menerangi jalan di dalam kegelapan ujian.',
    source: 'HR. Muslim',
    tags: ['sabar', 'cahaya', 'ujian'],
    isHadithStrong: true,
  ),
  ReelItem(
    id: 'sb004',
    category: ReelCategory.sabar,
    type: ReelType.quote,
    indonesia: 'Sabar bukan tentang menunggu, tapi tentang bagaimana sikapmu saat menunggu.',
    reflection: 'Kualitas kesabaran terlihat dari ketenangan hati, bukan lamanya waktu.',
    source: 'Hikmah Ulama',
    tags: ['sabar', 'sikap', 'menunggu'],
  ),
  ReelItem(
    id: 'sb005',
    category: ReelCategory.sabar,
    type: ReelType.ayat,
    arabic: 'إِنَّمَا يُوَفَّى الصَّابِرُونَ أَجْرَهُمْ بِغَيْرِ حِسَابٍ',
    indonesia: 'Sesungguhnya orang-orang yang sabar akan disempurnakan pahala mereka tanpa batas.',
    reflection: 'Pahala kesabaran tidak terhingga - inilah investasi terbaik.',
    source: 'QS. Az-Zumar: 10',
    tags: ['sabar', 'pahala', 'tanpa-batas'],
  ),
  ReelItem(
    id: 'sb006',
    category: ReelCategory.sabar,
    type: ReelType.hadith,
    indonesia: 'Tidak ada pemberian yang lebih baik dan lebih luas yang diberikan kepada seseorang selain kesabaran.',
    reflection: 'Kesabaran adalah anugerah tertinggi dari Allah.',
    source: 'HR. Bukhari & Muslim',
    tags: ['sabar', 'anugerah', 'pemberian'],
    isHadithStrong: true,
  ),

  // ===== QONAAH =====
  ReelItem(
    id: 'qn001',
    category: ReelCategory.qonaah,
    type: ReelType.hadith,
    arabic: 'ارْضَ بِمَا قَسَمَ اللَّهُ لَكَ تَكُنْ أَغْنَى النَّاسِ',
    indonesia: 'Ridhailah apa yang Allah bagikan untukmu, niscaya engkau menjadi orang yang paling kaya.',
    reflection: 'Kekayaan sejati bukan di dompet, tapi di hati yang qonaah.',
    source: 'HR. Tirmidzi',
    tags: ['qonaah', 'ridha', 'kaya'],
    isHadithStrong: true,
  ),
  ReelItem(
    id: 'qn002',
    category: ReelCategory.qonaah,
    type: ReelType.hadith,
    arabic: 'لَيْسَ الْغِنَى عَنْ كَثْرَةِ الْعَرَضِ وَلَكِنَّ الْغِنَى غِنَى النَّفْسِ',
    indonesia: 'Kekayaan bukanlah dengan banyaknya harta, tetapi kekayaan adalah kekayaan jiwa.',
    reflection: 'Jiwa yang kaya adalah jiwa yang merasa cukup.',
    source: 'HR. Bukhari & Muslim',
    tags: ['qonaah', 'kekayaan', 'jiwa'],
    isHadithStrong: true,
  ),
  ReelItem(
    id: 'qn003',
    category: ReelCategory.qonaah,
    type: ReelType.quote,
    indonesia: 'Orang yang qonaah memandang ke bawah untuk bersyukur, dan memandang ke atas untuk berusaha.',
    reflection: 'Qonaah bukan pasrah, tapi bersyukur sambil terus berikhtiar.',
    source: 'Hikmah Ulama',
    tags: ['qonaah', 'syukur', 'ikhtiar'],
  ),
  ReelItem(
    id: 'qn004',
    category: ReelCategory.qonaah,
    type: ReelType.ayat,
    arabic: 'لَئِنْ شَكَرْتُمْ لَأَزِيدَنَّكُمْ',
    indonesia: 'Jika kamu bersyukur, sungguh Aku akan menambah (nikmat) kepadamu.',
    reflection: 'Syukur adalah kunci pembuka pintu rezeki.',
    source: 'QS. Ibrahim: 7',
    tags: ['syukur', 'rezeki', 'tambah'],
  ),
  ReelItem(
    id: 'qn005',
    category: ReelCategory.qonaah,
    type: ReelType.hadith,
    indonesia: 'Lihatlah orang yang di bawahmu, jangan lihat orang yang di atasmu. Itu lebih layak agar kamu tidak meremehkan nikmat Allah.',
    reflection: 'Cara terbaik untuk bersyukur adalah membandingkan dengan yang kurang beruntung.',
    source: 'HR. Bukhari & Muslim',
    tags: ['syukur', 'qonaah', 'nikmat'],
    isHadithStrong: true,
  ),
  ReelItem(
    id: 'qn006',
    category: ReelCategory.qonaah,
    type: ReelType.quote,
    indonesia: 'Jangan mengeluh tentang apa yang tidak kamu miliki. Bersyukurlah atas apa yang ada, karena itulah yang terbaik untukmu saat ini.',
    reflection: 'Qonaah dimulai dari hati yang berhenti mengeluh.',
    source: 'Hikmah Ulama',
    tags: ['qonaah', 'syukur', 'keluhan'],
  ),

  // ===== BONUS MIXED =====
  ReelItem(
    id: 'mx001',
    category: ReelCategory.fiqhMuamalah,
    type: ReelType.quote,
    indonesia: 'Harta yang halal membawa berkah, harta yang haram membawa bencana.',
    reflection: 'Kehalalan sumber rezeki menentukan kualitas hidup.',
    source: 'Hikmah Salaf',
    tags: ['halal', 'haram', 'berkah'],
  ),
  ReelItem(
    id: 'mx002',
    category: ReelCategory.takdir,
    type: ReelType.quote,
    indonesia: 'Berusahalah seolah segalanya bergantung padamu, berdoalah seolah segalanya bergantung pada Allah.',
    reflection: 'Keseimbangan antara ikhtiar dan tawakkal.',
    source: 'Hikmah Ulama',
    tags: ['ikhtiar', 'tawakkal', 'doa'],
  ),
  ReelItem(
    id: 'mx003',
    category: ReelCategory.sabar,
    type: ReelType.ayat,
    arabic: 'فَاصْبِرْ صَبْرًا جَمِيلًا',
    indonesia: 'Maka bersabarlah dengan sabar yang indah.',
    reflection: 'Sabar yang indah adalah sabar tanpa keluhan.',
    source: 'QS. Al-Maarij: 5',
    tags: ['sabar', 'indah', 'tanpa-keluhan'],
  ),
  ReelItem(
    id: 'mx004',
    category: ReelCategory.qonaah,
    type: ReelType.ayat,
    arabic: 'وَمَا بِكُمْ مِنْ نِعْمَةٍ فَمِنَ اللَّهِ',
    indonesia: 'Dan nikmat apa pun yang ada padamu, maka itu dari Allah.',
    reflection: 'Semua nikmat adalah pemberian - bukan hasil usaha semata.',
    source: 'QS. An-Nahl: 53',
    tags: ['nikmat', 'Allah', 'syukur'],
  ),
];
