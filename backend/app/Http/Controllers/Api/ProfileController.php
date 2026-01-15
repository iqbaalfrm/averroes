<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function show(Request $request)
    {
        return response()->json([
            'profile' => $request->user()->profile,
        ]);
    }

    public function update(Request $request)
    {
        $data = $request->validate([
            'display_name' => ['nullable', 'string', 'max:120'],
            'avatar_url' => ['nullable', 'string'],
        ]);

        $profile = $request->user()->profile;
        $profile->fill($data);
        $profile->save();

        return response()->json([
            'profile' => $profile,
        ]);
    }
}
