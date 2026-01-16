import 'diskusi_models.dart';

List<DiskusiThread> buildDiskusiDummyThreads() {
  final userA = DiskusiUser(id: 'u1', name: 'Alya N');
  final userB = DiskusiUser(id: 'u2', name: 'Rafi H');
  final userC = DiskusiUser(id: 'u3', name: 'Syifa M');
  final userD = DiskusiUser(id: 'u4', name: 'Anonim', isAnonymous: true);

  return [
    DiskusiThread(
      id: 't1',
      title: 'Apakah staking termasuk akad yang dibolehkan?',
      description:
          'Aku masih bingung apakah staking itu masuk kategori ijarah atau malah gharar. Ada yang punya referensi?',
      category: 'Fikih',
      author: userA,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isLocal: true,
      replies: [
        DiskusiReply(
          id: 'r1',
          threadId: 't1',
          author: userB,
          content:
              'Kalau mengacu ke prinsip ijarah, harus jelas manfaat dan risiko. Beberapa ulama membolehkan dengan syarat asetnya jelas dan tidak spekulatif.',
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
          helpfulCount: 3,
        ),
        DiskusiReply(
          id: 'r2',
          threadId: 't1',
          author: userC,
          content:
              'Aku pernah baca pembahasan di DSN MUI soal akad jasa. Staking yang jelas produknya lebih aman, tapi tetap perlu kehati-hatian.',
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 5)),
          helpfulCount: 2,
        ),
      ],
      helpfulCount: 5,
      isAnswered: false,
    ),
    DiskusiThread(
      id: 't2',
      title: 'Tips sederhana biar nggak takut ketinggalan saat pasar rame',
      description:
          'Ada cara praktis supaya tetap tenang dan nggak ikut-ikutan?',
      category: 'Refleksi',
      author: userD,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isLocal: true,
      replies: [
        DiskusiReply(
          id: 'r3',
          threadId: 't2',
          author: userA,
          content:
              '**Checklist kecilku:**\n- Pastiin niat & tujuan\n- Cek data sebelum beli\n- Istirahat 10 menit sebelum klik',
          createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 40)),
          helpfulCount: 4,
        ),
      ],
      helpfulCount: 8,
      isAnswered: true,
    ),
    DiskusiThread(
      id: 't3',
      title: 'Zakat untuk aset digital yang baru 6 bulan?',
      description:
          'Kalau aset kripto belum sampai 1 tahun tapi nilainya sudah nisab, apakah wajib zakat?',
      category: 'Zakat',
      author: userB,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isLocal: true,
      replies: [
        DiskusiReply(
          id: 'r4',
          threadId: 't3',
          author: userC,
          content:
              'Umumnya zakat butuh haul 1 tahun. Tapi ada pendapat yang membolehkan bayar lebih awal sebagai sedekah, biar hati tenang.',
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          helpfulCount: 2,
        ),
      ],
      helpfulCount: 2,
      isAnswered: false,
    ),
    DiskusiThread(
      id: 't4',
      title: 'Bagaimana menilai proyek kripto dari sisi syariah?',
      description:
          'Apa indikator utama biar nggak salah pilih proyek?',
      category: 'Kripto',
      author: userC,
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      isLocal: true,
      replies: [],
      helpfulCount: 1,
      isAnswered: false,
    ),
    DiskusiThread(
      id: 't5',
      title: 'Mengatur target investasi supaya tetap qanaah',
      description:
          'Aku takut target terlalu tinggi jadi nggak bersyukur. Ada tips?',
      category: 'Refleksi',
      author: userA,
      createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
      isLocal: true,
      replies: [
        DiskusiReply(
          id: 'r5',
          threadId: 't5',
          author: userB,
          content:
              'Coba bikin target bertahap dan sertakan target non-finansial, kayak lebih disiplin atau lebih paham risiko.',
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 5)),
          helpfulCount: 1,
        ),
      ],
      helpfulCount: 4,
      isAnswered: false,
    ),
  ];
}
