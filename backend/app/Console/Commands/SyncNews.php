<?php

namespace App\Console\Commands;

use App\Models\Article;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;

class SyncNews extends Command
{
    protected $signature = 'news:sync';
    protected $description = 'Sync berita dari Google News RSS';

    public function handle(): int
    {
        $sources = [
            'https://news.google.com/rss/search?q=crypto%20syariah&hl=id&gl=ID&ceid=ID:id',
            'https://news.google.com/rss/search?q=ekonomi%20islam&hl=id&gl=ID&ceid=ID:id',
            'https://news.google.com/rss/search?q=blockchain%20halal&hl=id&gl=ID&ceid=ID:id',
        ];

        $inserted = 0;
        $updated = 0;

        foreach ($sources as $url) {
            $response = Http::timeout(15)->get($url);
            if (! $response->ok()) {
                $this->warn('Gagal fetch: ' . $url);
                continue;
            }

            $items = $this->parseRss($response->body());
            foreach ($items as $item) {
                $existing = Article::where('url', $item['url'])->first();
                if ($existing) {
                    $existing->fill($item)->save();
                    $updated++;
                } else {
                    Article::create($item);
                    $inserted++;
                }
            }
        }

        $this->cleanupOld();

        $this->info("Sync selesai. Inserted: {$inserted}, Updated: {$updated}");
        return Command::SUCCESS;
    }

    private function parseRss(string $xml): array
    {
        $results = [];
        libxml_use_internal_errors(true);
        $feed = simplexml_load_string($xml, 'SimpleXMLElement', LIBXML_NOCDATA);
        if (! $feed || ! isset($feed->channel->item)) {
            return $results;
        }

        foreach ($feed->channel->item as $item) {
            $link = (string) ($item->link ?? '');
            if (! $link) {
                continue;
            }

            $title = html_entity_decode((string) ($item->title ?? ''), ENT_QUOTES | ENT_HTML5);
            $source = (string) ($item->source ?? 'Google News');
            $published = (string) ($item->pubDate ?? '');
            $publishedAt = $published ? date('Y-m-d H:i:s', strtotime($published)) : now()->toDateTimeString();
            $imageUrl = $this->extractImage($item);

            $results[] = [
                'title' => $title ?: 'Berita terbaru',
                'source' => $source,
                'url' => $link,
                'image_url' => $imageUrl,
                'published_at' => $publishedAt,
            ];
        }

        return $results;
    }

    private function extractImage($item): ?string
    {
        $namespaces = $item->getNameSpaces(true);
        if (isset($namespaces['media'])) {
            $media = $item->children($namespaces['media']);
            if (isset($media->content)) {
                $attributes = $media->content->attributes();
                if (isset($attributes['url'])) {
                    return (string) $attributes['url'];
                }
            }
            if (isset($media->thumbnail)) {
                $attributes = $media->thumbnail->attributes();
                if (isset($attributes['url'])) {
                    return (string) $attributes['url'];
                }
            }
        }

        $description = (string) ($item->description ?? '');
        if (preg_match('/<img[^>]+src="([^"]+)"/i', $description, $matches)) {
            return $matches[1];
        }

        return null;
    }

    private function cleanupOld(): void
    {
        $ids = Article::orderByDesc('published_at')
            ->skip(200)
            ->take(1000)
            ->pluck('id');

        if ($ids->isNotEmpty()) {
            Article::whereIn('id', $ids)->delete();
        }
    }
}
