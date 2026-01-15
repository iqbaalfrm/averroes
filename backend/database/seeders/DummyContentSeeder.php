<?php

namespace Database\Seeders;

use App\Models\Article;
use App\Models\Book;
use App\Models\ClassLesson;
use App\Models\ClassModule;
use App\Models\EdukasiClass;
use App\Models\MarketCoin;
use App\Models\ReelItem;
use App\Models\ScreenerCoin;
use Illuminate\Database\Seeder;

class DummyContentSeeder extends Seeder
{
    public function run(): void
    {
        $this->seedScreener();
        $this->seedMarket();
        $this->seedClasses();
        $this->seedBooks();
        $this->seedReels();
        $this->seedArticles();
    }

    private function seedScreener(): void
    {
        $items = [
            ['BTC', 'Bitcoin', 'Halal'],
            ['ETH', 'Ethereum', 'Proses'],
            ['BNB', 'BNB', 'Risiko Tinggi'],
            ['SOL', 'Solana', 'Proses'],
        ];

        foreach ($items as $item) {
            ScreenerCoin::updateOrCreate(
                ['code' => $item[0]],
                [
                    'name' => $item[1],
                    'status' => $item[2],
                    'price_usd' => rand(1, 50000),
                    'market_cap_usd' => rand(1000000, 100000000),
                    'explanation' => 'Informasi ringkas untuk keperluan demo.',
                    'details' => ['Sumber: demo'],
                ]
            );
        }
    }

    private function seedMarket(): void
    {
        $items = [
            ['BTC', 'Bitcoin'],
            ['ETH', 'Ethereum'],
            ['BNB', 'BNB'],
            ['SOL', 'Solana'],
        ];

        foreach ($items as $item) {
            MarketCoin::updateOrCreate(
                ['code' => $item[0]],
                [
                    'name' => $item[1],
                    'price_usd' => rand(1, 50000),
                    'change_24h' => rand(-500, 500) / 100,
                    'change_7d' => rand(-500, 500) / 100,
                    'volume_usd' => rand(1000000, 100000000),
                    'market_cap_usd' => rand(1000000, 100000000),
                ]
            );
        }
    }

    private function seedClasses(): void
    {
        $classes = [
            [
                'title' => 'Dasar Crypto Syariah',
                'subtitle' => 'Pahami pondasi halal-haram aset digital',
                'level' => 'Pemula',
                'duration_text' => '2 Jam',
                'lessons_count' => 8,
                'description' => 'Kelas pengantar crypto syariah untuk pemula.',
                'outcomes' => ['Ngerti istilah', 'Beda halal/haram/syubhat', 'Cara baca market basic'],
                'cover_theme' => 'mint',
            ],
            [
                'title' => 'Fiqh Muamalah untuk Aset Digital',
                'subtitle' => 'Landasan hukum untuk transaksi modern',
                'level' => 'Menengah',
                'duration_text' => '3 Jam',
                'lessons_count' => 10,
                'description' => 'Pembahasan fiqh muamalah pada aset digital.',
                'outcomes' => ['Prinsip muamalah', 'Case study', 'Panduan praktis'],
                'cover_theme' => 'sand',
            ],
        ];

        foreach ($classes as $classData) {
            $class = EdukasiClass::updateOrCreate(
                ['title' => $classData['title']],
                $classData
            );

            $module = ClassModule::updateOrCreate(
                ['class_id' => $class->id, 'title' => 'Pengantar'],
                ['sort_order' => 1]
            );

            ClassLesson::updateOrCreate(
                ['module_id' => $module->id, 'title' => 'Selamat Datang'],
                [
                    'type' => 'reading',
                    'duration_min' => 8,
                    'content' => 'Konten demo untuk lesson awal.',
                    'sort_order' => 1,
                ]
            );
        }
    }

    private function seedBooks(): void
    {
        $books = [
            [
                'display_title' => 'Hukum Fikih tentang Uang Kertas (Fiat)',
                'original_title' => 'Hukum Fiqih terhadap Uang Kertas(fiat)',
                'author' => 'Majelis Fiqih',
                'language' => 'id',
                'category' => 'Fiqh',
                'pages' => 64,
                'description' => 'Ringkasan hukum fikih terkait uang kertas.',
                'pdf_url' => 'https://drive.google.com/file/d/demo-fiat',
                'cover_url' => null,
            ],
            [
                'display_title' => 'Al-Ahkām al-Fiqhiyyah terkait Mata Uang Elektronik',
                'original_title' => "a l - a h k ā m a l - f i q h i y y a h a l - m u t a ‘ a l l i q a b i l - ‘ u m a l a a t a l - i l i k t i r ū n i y y a h",
                'author' => "Al-Majma' Al-Fiqhi",
                'language' => 'ar',
                'category' => 'Fiqh',
                'pages' => 120,
                'description' => 'Kajian mendalam tentang uang elektronik.',
                'pdf_url' => 'https://drive.google.com/file/d/demo-electronic',
                'cover_url' => null,
            ],
        ];

        foreach ($books as $book) {
            Book::updateOrCreate(['original_title' => $book['original_title']], $book);
        }
    }

    private function seedReels(): void
    {
        for ($i = 1; $i <= 20; $i++) {
            ReelItem::updateOrCreate(
                ['text_id' => "Hikmah singkat ke-{$i}"],
                [
                    'theme' => 'sabar',
                    'text_ar' => null,
                    'audio_url' => null,
                    'source' => 'Averroes',
                    'category' => 'hikmah',
                    'type' => 'text',
                    'is_active' => true,
                    'order_index' => $i,
                ]
            );
        }
    }

    private function seedArticles(): void
    {
        for ($i = 1; $i <= 20; $i++) {
            Article::updateOrCreate(
                ['url' => 'https://news.example.com/item-' . $i],
                [
                    'title' => 'Berita Crypto Syariah #' . $i,
                    'source' => 'Averroes News',
                    'image_url' => null,
                    'published_at' => now()->subHours($i),
                ]
            );
        }
    }
}
