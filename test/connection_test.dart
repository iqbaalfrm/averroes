import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('Test Supabase Connection', () async {
    print('\n🚀 MEMULAI TES KONEKSI SUPABASE...');

    final envFile = File('.env');
    if (!envFile.existsSync()) {
      print('❌ File .env TIDAK DITEMUKAN!');
      return;
    }

    final lines = envFile.readAsLinesSync();
    String? url;
    String? key;

    for (final line in lines) {
      if (line.startsWith('SUPABASE_URL=')) {
        url = line.substring('SUPABASE_URL='.length).trim();
      } else if (line.startsWith('SUPABASE_ANON_KEY=')) {
        key = line.substring('SUPABASE_ANON_KEY='.length).trim();
      }
    }

    if (url == null || url.isEmpty || url.contains('your-project-id')) {
        print('❌ SUPABASE_URL belum diisi dengan benar di .env');
        return;
    }
    if (key == null || key.isEmpty || key.contains('your-supabase-anon-key')) {
        print('❌ SUPABASE_ANON_KEY belum diisi dengan benar di .env');
        return;
    }

    print('📝 URL Found: $url');
    print('🔑 Key Found: ${key.substring(0, 10)}...');

    try {
      // Menggunakan SupabaseClient langsung (dart core)
      final client = SupabaseClient(url, key);
      
      print('🔄 Mencoba menghubungi server...');
      
      try {
        // Coba query tabel sembarang untuk memancing response server
        // Kita gunakan .select().limit(0) untuk efisiensi
        await client.from('portfolio_holdings').select().limit(0);
        print('✅ KONEKSI SUKSES! Server merespons dengan data/kosong.');
      } catch (e) {
        final msg = e.toString();
        // Jika errornya adalah tabel tidak ditemukan, berarti koneksi sukses!
        // Jika errornya network, berarti gagal.
        
        if (msg.contains('SocketException') || msg.contains('ClientException') || msg.contains('host lookup')) {
           print('❌ KONEKSI GAGAL: Tidak bisa menghubungi server. Cek internet URL.');
           print('Detail: $msg');
        } else {
           print('✅ KONEKSI SUKSES! Server merespons (meskipun ada error database permission/notfound).');
           print('Info Response: $msg');
        }
      }
      
    } catch (e) {
       print('❌ Error tak terduga: $e');
    }
    
    print('🏁 TES SELESAI\n');
  });
}
