<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ArticleResource;
use App\Models\Article;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class NewsController extends Controller
{
    public function index(Request $request)
    {
        $limit = (int) $request->query('limit', 0);
        $perPage = (int) $request->query('per_page', 20);

        $query = Article::query()
            ->where('status', 'terbit')
            ->orderByDesc('published_at');

        if ($limit > 0) {
            return response()->json([
                'data' => ArticleResource::collection($query->limit($limit)->get()),
            ]);
        }

        return ArticleResource::collection($query->paginate($perPage))->response();
    }

    public function latest(Request $request)
    {
        $limit = (int) $request->query('limit', 5);
        $articles = Article::where('status', 'terbit')
            ->orderByDesc('published_at')
            ->limit($limit)
            ->get();

        return response()->json(['data' => ArticleResource::collection($articles)]);
    }

    public function show(string $slug)
    {
        $article = Article::where('slug', $slug)
            ->orWhere('id', $slug)
            ->firstOrFail();

        if (!$article->slug) {
            $article->slug = Str::slug($article->title);
            $article->save();
        }

        return response()->json(['data' => new ArticleResource($article)]);
    }

    public function destroy(string $id)
    {
        Article::where('id', $id)->delete();

        return response()->json(['message' => 'Berita dihapus.']);
    }
}
