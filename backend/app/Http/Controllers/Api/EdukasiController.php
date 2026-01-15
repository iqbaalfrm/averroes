<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\EdukasiClass;
use App\Models\UserClassProgress;
use Illuminate\Http\Request;

class EdukasiController extends Controller
{
    public function index(Request $request)
    {
        $withModules = $request->query('with_modules', '1') === '1';
        $query = EdukasiClass::query();

        if ($withModules) {
            $query->with(['modules.lessons' => function ($lessonQuery) {
                $lessonQuery->orderBy('sort_order');
            }]);
        }

        return response()->json([
            'data' => $query->orderBy('created_at', 'desc')->get(),
        ]);
    }

    public function show(string $id)
    {
        $class = EdukasiClass::with(['modules.lessons' => function ($query) {
            $query->orderBy('sort_order');
        }])->findOrFail($id);

        return response()->json(['data' => $class]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'title' => ['required', 'string'],
            'subtitle' => ['nullable', 'string'],
            'level' => ['required', 'string'],
            'duration_text' => ['nullable', 'string'],
            'lessons_count' => ['nullable', 'integer'],
            'description' => ['nullable', 'string'],
            'outcomes' => ['nullable', 'array'],
            'cover_theme' => ['nullable', 'string'],
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
            'lessons_count' => ['nullable', 'integer'],
            'description' => ['nullable', 'string'],
            'outcomes' => ['nullable', 'array'],
            'cover_theme' => ['nullable', 'string'],
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
