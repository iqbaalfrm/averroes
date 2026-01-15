<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ScreenerCoin;
use Illuminate\Http\Request;

class ScreenerController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => ScreenerCoin::orderBy('name')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'code' => ['required', 'string'],
            'name' => ['required', 'string'],
            'status' => ['required', 'string'],
            'price_usd' => ['nullable', 'numeric'],
            'market_cap_usd' => ['nullable', 'numeric'],
            'explanation' => ['nullable', 'string'],
            'details' => ['nullable', 'array'],
        ]);

        $coin = ScreenerCoin::create($data);

        return response()->json(['data' => $coin], 201);
    }

    public function update(Request $request, string $id)
    {
        $data = $request->validate([
            'code' => ['sometimes', 'string'],
            'name' => ['sometimes', 'string'],
            'status' => ['sometimes', 'string'],
            'price_usd' => ['nullable', 'numeric'],
            'market_cap_usd' => ['nullable', 'numeric'],
            'explanation' => ['nullable', 'string'],
            'details' => ['nullable', 'array'],
        ]);

        $coin = ScreenerCoin::findOrFail($id);
        $coin->fill($data)->save();

        return response()->json(['data' => $coin]);
    }

    public function destroy(string $id)
    {
        ScreenerCoin::where('id', $id)->delete();

        return response()->json(['message' => 'Item dihapus.']);
    }
}
