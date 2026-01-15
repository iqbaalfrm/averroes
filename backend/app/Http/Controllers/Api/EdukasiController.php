<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\EdukasiClassResource;
use App\Models\EdukasiClass;
use App\Models\UserClassProgress;
use Illuminate\Http\Request;

class EdukasiController extends Controller
{
    public function index(Request $request)
    {
        $query = EdukasiClass::query()
            ->where('status', 'published')
            ->with(['modules.lessons' => function ($lessonQuery) {
                $lessonQuery->orderBy('sort_order');
            }])
            ->orderBy('created_at', 'desc');

        return response()->json([
            'data' => EdukasiClassResource::collection($query->get()),
        ]);
    }

    public function show(string $id)
    {
        $class = EdukasiClass::with(['modules.lessons' => function ($query) {
            $query->orderBy('sort_order');
        }])->findOrFail($id);

        return response()->json(['data' => new EdukasiClassResource($class)]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'title' => ['required', 'string'],
            'subtitle' => ['nullable', 'string'],
            'level' => ['required', 'string'],
            'duration_text' => ['nullable', 'string'],
            'duration_minutes' => ['nullable', 'integer'],
            'lessons_count' => ['nullable', 'integer'],
            'short_desc' => ['nullable', 'string'],
            'description' => ['nullable', 'string'],
            'outcomes' => ['nullable', 'array'],
            'cover_theme' => ['nullable', 'string'],
            'cover_image_url' => ['nullable', 'string'],
            'status' => ['nullable', 'string'],
        ]);

        $class = EdukasiClass::create($data);

        return response()->json(['data' => $class], 201);
    }

    public function update(Request $request, string $id)
    {
        $data = $request->validate([
            'title' => ['sometimes', 'string'],
            'subtitle' => ['nullable', 'string'],
            'level' => ['sometimes', 'string'],
            'duration_text' => ['nullable', 'string'],
            'duration_minutes' => ['nullable', 'integer'],
            'lessons_count' => ['nullable', 'integer'],
            'short_desc' => ['nullable', 'string'],
            'description' => ['nullable', 'string'],
            'outcomes' => ['nullable', 'array'],
            'cover_theme' => ['nullable', 'string'],
            'cover_image_url' => ['nullable', 'string'],
            'status' => ['nullable', 'string'],
        ]);

        $class = EdukasiClass::findOrFail($id);
        $class->fill($data)->save();

        return response()->json(['data' => $class]);
    }

    public function destroy(string $id)
    {
        EdukasiClass::where('id', $id)->delete();

        return response()->json(['message' => 'Kelas dihapus.']);
    }

    public function getProgress(Request $request, string $id)
    {
        $progress = UserClassProgress::where('user_id', $request->user()->id)
            ->where('class_id', $id)
            ->first();

        return response()->json(['data' => $progress]);
    }

    public function saveProgress(Request $request, string $id)
    {
        $data = $request->validate([
            'last_lesson_id' => ['nullable', 'string'],
            'progress' => ['nullable', 'numeric'],
            'completed_lessons' => ['nullable', 'array'],
        ]);

        $progress = UserClassProgress::updateOrCreate(
            ['user_id' => $request->user()->id, 'class_id' => $id],
            [
                'last_lesson_id' => $data['last_lesson_id'] ?? null,
                'progress' => $data['progress'] ?? 0,
                'completed_lessons' => $data['completed_lessons'] ?? [],
            ]
        );

        return response()->json(['data' => $progress]);
    }
}
