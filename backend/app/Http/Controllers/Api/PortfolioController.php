<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PortfolioAsset;
use Illuminate\Http\Request;

class PortfolioController extends Controller
{
    public function index(Request $request)
    {
        return response()->json([
            'data' => PortfolioAsset::where('user_id', $request->user()->id)
                ->orderBy('created_at', 'desc')
                ->get(),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'coin_code' => ['required', 'string'],
            'coin_name' => ['required', 'string'],
            'network' => ['nullable', 'string'],
            'amount' => ['required', 'numeric'],
            'avg_buy_price_usd' => ['nullable', 'numeric'],
            'notes' => ['nullable', 'string'],
        ]);

        $asset = PortfolioAsset::create(array_merge($data, [
            'user_id' => $request->user()->id,
        ]));

        return response()->json(['data' => $asset], 201);
    }

    public function update(Request $request, string $id)
    {
        $data = $request->validate([
            'coin_code' => ['sometimes', 'string'],
            'coin_name' => ['sometimes', 'string'],
            'network' => ['nullable', 'string'],
            'amount' => ['nullable', 'numeric'],
            'avg_buy_price_usd' => ['nullable', 'numeric'],
            'notes' => ['nullable', 'string'],
        ]);

        $asset = PortfolioAsset::where('user_id', $request->user()->id)->findOrFail($id);
        $asset->fill($data)->save();

        return response()->json(['data' => $asset]);
    }

    public function destroy(Request $request, string $id)
    {
        PortfolioAsset::where('user_id', $request->user()->id)
            ->where('id', $id)
            ->delete();

        return response()->json(['message' => 'Asset dihapus.']);
    }
}
