<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\PortfolioAssetResource;
use App\Models\PortfolioAsset;
use Illuminate\Http\Request;

class PortfolioController extends Controller
{
    public function index(Request $request)
    {
        $assets = PortfolioAsset::where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'data' => PortfolioAssetResource::collection($assets),
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

        return response()->json(['data' => new PortfolioAssetResource($asset)], 201);
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

        return response()->json(['data' => new PortfolioAssetResource($asset)]);
    }

    public function destroy(Request $request, string $id)
    {
        PortfolioAsset::where('user_id', $request->user()->id)
            ->where('id', $id)
            ->delete();

        return response()->json(['message' => 'Asset dihapus.']);
    }
}
