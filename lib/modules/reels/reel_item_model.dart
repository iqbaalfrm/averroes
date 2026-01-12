class ReelItem {
  final String id;
  final String category;
  final String type;
  final String? arabic;
  final String indonesia;
  final String? reflection;
  final String source;
  final String? audioUrl;
  final int? durationSec;
  final String? verseKey; // e.g. "2:153"
  final int? surah;
  final int? ayah;

  ReelItem({
    required this.id,
    required this.category,
    required this.type,
    this.arabic,
    required this.indonesia,
    this.reflection,
    required this.source,
    this.audioUrl,
    this.durationSec,
    this.verseKey,
    this.surah,
    this.ayah,
  });

  factory ReelItem.fromJson(Map<String, dynamic> json) {
    return ReelItem(
      id: json['id'] ?? '',
      category: json['category'] ?? 'Umum',
      type: json['type'] ?? 'quote',
      arabic: json['arabic'],
      indonesia: json['indonesia'] ?? '',
      reflection: json['reflection'],
      source: json['source'] ?? '',
      audioUrl: json['audio_url'],
      durationSec: json['duration_sec'],
      verseKey: json['verse_key'],
      surah: json['surah'],
      ayah: json['ayah'],
    );
  }

  /// Returns a reliable audio URL, redirecting broken Islamic Network links to EveryAyah
  String? get playAudioUrl {
    if (audioUrl == null || audioUrl!.isEmpty) return null;
    
    // Redirect broken islamic.network links if we have surah/ayah info
    if (audioUrl!.contains('islamic.network') && surah != null && ayah != null) {
      final s = surah.toString().padLeft(3, '0');
      final a = ayah.toString().padLeft(3, '0');
      return 'https://www.everyayah.com/data/Alafasy_128kbps/$s$a.mp3';
    }
    
    return audioUrl;
  }
}
