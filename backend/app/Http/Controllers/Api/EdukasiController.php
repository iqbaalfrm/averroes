<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ClassCertificateResource;
use App\Http\Resources\ClassExamResource;
use App\Http\Resources\EdukasiClassResource;
use App\Http\Resources\LessonExerciseResource;
use App\Models\ClassCertificate;
use App\Models\ClassExam;
use App\Models\ClassExamAttempt;
use App\Models\ClassExamAnswer;
use App\Models\ClassExamOption;
use App\Models\EdukasiClass;
use App\Models\LessonExercise;
use App\Models\LessonExerciseAttempt;
use App\Models\LessonExerciseAnswer;
use App\Models\LessonExerciseOption;
use App\Models\UserClassProgress;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class EdukasiController extends Controller
{
    public function index(Request $request)
    {
        $query = EdukasiClass::query()
            ->where('status', 'terbit')
            ->with([
                'modules.lessons' => function ($lessonQuery) {
                    $lessonQuery->orderBy('sort_order')->with('exercise');
                },
                'exam',
            ])
            ->orderBy('created_at', 'desc');

        return response()->json([
            'data' => EdukasiClassResource::collection($query->get()),
        ]);
    }

    public function show(string $id)
    {
        $class = EdukasiClass::with([
            'modules.lessons' => function ($query) {
                $query->orderBy('sort_order')->with('exercise');
            },
            'exam',
        ])->findOrFail($id);

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

    public function lessonExercise(string $lessonId)
    {
        $exercise = LessonExercise::with([
            'questions' => function ($query) {
                $query->orderBy('sort_order')->with(['options' => function ($optionQuery) {
                    $optionQuery->orderBy('sort_order');
                }]);
            },
        ])
            ->where('lesson_id', $lessonId)
            ->where('is_active', true)
            ->firstOrFail();

        return response()->json(['data' => new LessonExerciseResource($exercise)]);
    }

    public function submitLessonExercise(Request $request, string $lessonId)
    {
        $exercise = LessonExercise::where('lesson_id', $lessonId)->firstOrFail();

        $data = $request->validate([
            'answers' => ['required', 'array'],
            'answers.*.question_id' => ['required', 'uuid'],
            'answers.*.option_id' => ['nullable', 'uuid'],
        ]);

        $questions = $exercise->questions()->get();
        $totalQuestions = $questions->count();

        $correctCount = 0;
        $attempt = LessonExerciseAttempt::create([
            'exercise_id' => $exercise->id,
            'user_id' => $request->user()->id,
            'started_at' => now(),
        ]);

        foreach ($data['answers'] as $answer) {
            $selectedOption = null;
            $isCorrect = false;

            if (!empty($answer['option_id'])) {
                $selectedOption = LessonExerciseOption::find($answer['option_id']);
                $isCorrect = $selectedOption?->is_correct ?? false;
            }

            if ($isCorrect) {
                $correctCount += 1;
            }

            LessonExerciseAnswer::create([
                'attempt_id' => $attempt->id,
                'question_id' => $answer['question_id'],
                'selected_option_id' => $answer['option_id'] ?? null,
                'is_correct' => $isCorrect,
            ]);
        }

        $score = $totalQuestions > 0 ? (int) round(($correctCount / $totalQuestions) * 100) : 0;
        $status = $score >= $exercise->passing_score ? 'lulus' : 'gagal';

        $attempt->fill([
            'score' => $score,
            'total_questions' => $totalQuestions,
            'correct_count' => $correctCount,
            'status' => $status,
            'finished_at' => now(),
        ])->save();

        return response()->json([
            'data' => [
                'attempt_id' => (string) $attempt->id,
                'score' => $score,
                'status' => $status,
                'passing_score' => $exercise->passing_score,
            ],
        ]);
    }

    public function classExam(string $classId)
    {
        $exam = ClassExam::with([
            'questions' => function ($query) {
                $query->orderBy('sort_order')->with(['options' => function ($optionQuery) {
                    $optionQuery->orderBy('sort_order');
                }]);
            },
        ])
            ->where('class_id', $classId)
            ->where('is_active', true)
            ->firstOrFail();

        return response()->json(['data' => new ClassExamResource($exam)]);
    }

    public function submitClassExam(Request $request, string $classId)
    {
        $exam = ClassExam::where('class_id', $classId)->firstOrFail();

        $data = $request->validate([
            'answers' => ['required', 'array'],
            'answers.*.question_id' => ['required', 'uuid'],
            'answers.*.option_id' => ['nullable', 'uuid'],
        ]);

        $questions = $exam->questions()->get();
        $totalQuestions = $questions->count();

        $correctCount = 0;
        $attempt = ClassExamAttempt::create([
            'exam_id' => $exam->id,
            'user_id' => $request->user()->id,
            'started_at' => now(),
        ]);

        foreach ($data['answers'] as $answer) {
            $selectedOption = null;
            $isCorrect = false;

            if (!empty($answer['option_id'])) {
                $selectedOption = ClassExamOption::find($answer['option_id']);
                $isCorrect = $selectedOption?->is_correct ?? false;
            }

            if ($isCorrect) {
                $correctCount += 1;
            }

            ClassExamAnswer::create([
                'attempt_id' => $attempt->id,
                'question_id' => $answer['question_id'],
                'selected_option_id' => $answer['option_id'] ?? null,
                'is_correct' => $isCorrect,
            ]);
        }

        $score = $totalQuestions > 0 ? (int) round(($correctCount / $totalQuestions) * 100) : 0;
        $status = $score >= $exam->passing_score ? 'lulus' : 'gagal';

        $attempt->fill([
            'score' => $score,
            'total_questions' => $totalQuestions,
            'correct_count' => $correctCount,
            'status' => $status,
            'finished_at' => now(),
        ])->save();

        $certificate = null;
        if ($status === 'lulus') {
            $certificate = ClassCertificate::firstOrCreate(
                [
                    'user_id' => $request->user()->id,
                    'class_id' => $classId,
                ],
                [
                    'certificate_number' => $this->generateCertificateNumber(),
                    'final_score' => $score,
                    'issued_at' => now(),
                    'qr_payload' => $this->buildCertificatePayload($classId, $request->user()->id),
                ]
            );
            $certificate->load('eduClass');
        }

        return response()->json([
            'data' => [
                'attempt_id' => (string) $attempt->id,
                'score' => $score,
                'status' => $status,
                'passing_score' => $exam->passing_score,
                'certificate' => $certificate ? new ClassCertificateResource($certificate) : null,
            ],
        ]);
    }

    public function certificates(Request $request)
    {
        $certificates = ClassCertificate::with('eduClass')
            ->where('user_id', $request->user()->id)
            ->orderByDesc('issued_at')
            ->get();

        return response()->json([
            'data' => ClassCertificateResource::collection($certificates),
        ]);
    }

    private function generateCertificateNumber(): string
    {
        return sprintf('AVR-%s-%s', now()->format('Ymd'), Str::upper(Str::random(6)));
    }

    private function buildCertificatePayload(string $classId, string $userId): string
    {
        return json_encode([
            'kelas_id' => $classId,
            'pengguna_id' => $userId,
            'issued_at' => now()->toISOString(),
        ]);
    }
}
