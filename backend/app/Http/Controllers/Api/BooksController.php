<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\BookResource;
use App\Models\Book;
use App\Models\UserBookmark;
use Illuminate\Http\Request;

class BooksController extends Controller
{
    public function index()
    {
        $books = Book::where('status', 'terbit')->orderBy('created_at', 'desc')->get();

        return response()->json([
            'data' => BookResource::collection($books),
        ]);
    }

    public function show(string $id)
    {
        return response()->json([
            'data' => new BookResource(Book::findOrFail($id)),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'original_title' => ['required', 'string'],
            'display_title' => ['nullable', 'string'],
            'author' => ['nullable', 'string'],
            'language' => ['nullable', 'string'],
            'category' => ['nullable', 'string'],
            'pages' => ['nullable', 'integer'],
            'description' => ['nullable', 'string'],
            'pdf_url' => ['required', 'string'],
            'cover_url' => ['nullable', 'string'],
            'cover_image_url' => ['nullable', 'string'],
            'status' => ['nullable', 'string'],
        ]);

        $book = Book::create($data);

        return response()->json(['data' => $book], 201);
    }

    public function update(Request $request, string $id)
    {
        $data = $request->validate([
            'original_title' => ['sometimes', 'string'],
            'display_title' => ['nullable', 'string'],
            'author' => ['nullable', 'string'],
            'language' => ['nullable', 'string'],
            'category' => ['nullable', 'string'],
            'pages' => ['nullable', 'integer'],
            'description' => ['nullable', 'string'],
            'pdf_url' => ['nullable', 'string'],
            'cover_url' => ['nullable', 'string'],
            'cover_image_url' => ['nullable', 'string'],
            'status' => ['nullable', 'string'],
        ]);

        $book = Book::findOrFail($id);
        $book->fill($data)->save();

        return response()->json(['data' => $book]);
    }

    public function destroy(string $id)
    {
        Book::where('id', $id)->delete();

        return response()->json(['message' => 'Buku dihapus.']);
    }

    public function bookmark(Request $request)
    {
        $data = $request->validate([
            'type' => ['required', 'string'],
            'ref_id' => ['required', 'string'],
        ]);

        $bookmark = UserBookmark::firstOrCreate([
            'user_id' => $request->user()->id,
            'type' => $data['type'],
            'ref_id' => $data['ref_id'],
        ]);

        return response()->json(['data' => $bookmark], 201);
    }

    public function removeBookmark(Request $request)
    {
        $data = $request->validate([
            'type' => ['required', 'string'],
            'ref_id' => ['required', 'string'],
        ]);

        UserBookmark::where('user_id', $request->user()->id)
            ->where('type', $data['type'])
            ->where('ref_id', $data['ref_id'])
            ->delete();

        return response()->json(['message' => 'Bookmark dihapus.']);
    }
}
