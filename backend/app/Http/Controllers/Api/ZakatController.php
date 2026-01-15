<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ZakatRecord;
use Illuminate\Http\Request;

class ZakatController extends Controller
{
    public function calculate(Request $request)
    {
        $data = $request->validate([
            'total_assets_idr' => ['required', 'numeric'],
            'gold_price_idr_per_gram' => ['required', 'numeric'],
        ]);

        $nishab = $data['gold_price_idr_per_gram'] * 85;
        $zakatDue = $data['total_assets_idr'] >= $nishab
            ? $data['total_assets_idr'] * 0.025
            : 0;

        return response()->json([
            'total_assets_idr' => $data['total_assets_idr'],
            'gold_price_idr_per_gram' => $data['gold_price_idr_per_gram'],
            'nishab_idr' => $nishab,
            'zakat_due_idr' => $zakatDue,
        ]);
    }

    public function index(Request $request)
    {
        return response()->json([
            'data' => ZakatRecord::where('user_id', $request->user()->id)
                ->orderBy('created_at', 'desc')
                ->get(),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'total_assets_idr' => ['required', 'numeric'],
            'gold_price_idr_per_gram' => ['required', 'numeric'],
            'nishab_idr' => ['required', 'numeric'],
            'zakat_due_idr' => ['required', 'numeric'],
            'method' => ['nullable', 'string'],
        ]);

        $record = ZakatRecord::create(array_merge($data, [
            'user_id' => $request->user()->id,
        ]));

        return response()->json(['data' => $record], 201);
    }
}
