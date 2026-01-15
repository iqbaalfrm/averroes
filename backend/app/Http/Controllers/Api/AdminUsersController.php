<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Profile;
use Illuminate\Http\Request;

class AdminUsersController extends Controller
{
    public function index()
    {
        $profiles = Profile::orderBy('created_at', 'desc')->get();

        return response()->json(['data' => $profiles]);
    }

    public function updateRole(Request $request, string $id)
    {
        $data = $request->validate([
            'role' => ['required', 'string'],
        ]);

        $profile = Profile::findOrFail($id);
        $profile->role = $data['role'];
        $profile->save();

        return response()->json(['data' => $profile]);
    }

    public function updateBan(Request $request, string $id)
    {
        $data = $request->validate([
            'is_banned' => ['required', 'boolean'],
        ]);

        $profile = Profile::findOrFail($id);
        $profile->is_banned = $data['is_banned'];
        $profile->save();

        return response()->json(['data' => $profile]);
    }
}
