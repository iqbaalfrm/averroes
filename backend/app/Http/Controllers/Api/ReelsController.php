<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ReelItem;
use Illuminate\Http\Request;

class ReelsController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => ReelItem::where('is_active', true)->orderBy('order_index')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'theme' => ['required', 'string'],
            'text_ar' => ['nullable', 'string'],
            'text_id' => ['required', 'string'],
            'audio_url' => ['nullable', 'string'],
            'source' => ['nullable', 'string'],
            'category' => ['nullable', 'string'],
            'verse_ref' => ['nullable', 'string'],
            'type' => ['nullable', 'string'],
            'is_active' => ['nullable', 'boolean'],
            'order_index' => ['nullable', 'integer'],
        ]);

        $item = ReelItem::create($data);

        return response()->json(['data' => $item], 201);
    }

    public function update(Request $request, string $id)
    {
        $data = $request->validate([
            'theme' => ['sometimes', 'string'],
            'text_ar' => ['nullable', 'string'],
            'text_id' => ['sometimes', 'string'],
            'audio_url' => ['nullable', 'string'],
            'source' => ['nullable', 'string'],
            'category' => ['nullable', 'string'],
            'verse_ref' => ['nullable', 'string'],
            'type' => ['nullable', 'string'],
            'is_active' => ['nullable', 'boolean'],
            'order_index' => ['nullable', 'integer'],
        ]);

        $item = ReelItem::findOrFail($id);
        $item->fill($data)->save();

        return response()->json(['data' => $item]);
    }

    public function destroy(string $id)
    {
        ReelItem::where('id', $id)->delete();

        return response()->json(['message' => 'Reels dihapus.']);
    }
}
