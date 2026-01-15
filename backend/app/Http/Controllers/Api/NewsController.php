<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Article;
use Illuminate\Http\Request;

class NewsController extends Controller
{
    public function index(Request $request)
    {
        $perPage = (int) $request->query('per_page', 20);
        $articles = Article::orderByDesc('published_at')->paginate($perPage);

        return response()->json($articles);
    }

    public function latest(Request $request)
    {
        $limit = (int) $request->query('limit', 5);
        $articles = Article::orderByDesc('published_at')->limit($limit)->get();

        return response()->json(['data' => $articles]);
    }

    public function destroy(string $id)
    {
        Article::where('id', $id)->delete();

        return response()->json(['message' => 'Berita dihapus.']);
    }
}
