<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MarketCoin;
use Illuminate\Http\Request;

class MarketController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => MarketCoin::orderBy('market_cap_usd', 'desc')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'code' => ['required', 'string'],
            'name' => ['required', 'string'],
            'price_usd' => ['nullable', 'numeric'],
            'change_24h' => ['nullable', 'numeric'],
            'change_7d' => ['nullable', 'numeric'],
            'volume_usd' => ['nullable', 'numeric'],
            'market_cap_usd' => ['nullable', 'numeric'],
        ]);

        $coin = MarketCoin::create($data);

        return response()->json(['data' => $coin], 201);
    }

    public function update(Request $request, string $id)
    {
        $data = $request->validate([
            'code' => ['sometimes', 'string'],
            'name' => ['sometimes', 'string'],
            'price_usd' => ['nullable', 'numeric'],
            'change_24h' => ['nullable', 'numeric'],
            'change_7d' => ['nullable', 'numeric'],
            'volume_usd' => ['nullable', 'numeric'],
            'market_cap_usd' => ['nullable', 'numeric'],
        ]);

        $coin = MarketCoin::findOrFail($id);
        $coin->fill($data)->save();

        return response()->json(['data' => $coin]);
    }

    public function destroy(string $id)
    {
        MarketCoin::where('id', $id)->delete();

        return response()->json(['message' => 'Item dihapus.']);
    }
}
