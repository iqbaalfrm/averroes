<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ForumReplyResource;
use App\Http\Resources\ForumThreadResource;
use App\Models\ForumLike;
use App\Models\ForumReply;
use App\Models\ForumThread;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ForumController extends Controller
{
    public function index(Request $request)
    {
        $query = ForumThread::query()
            ->where('is_hidden', false)
            ->where('status', 'open');

        if ($category = $request->query('category')) {
            $query->where('category', $category);
        }

        $sort = $request->query('sort', 'latest');
        if ($sort === 'popular') {
            $query->orderByDesc('reply_count');
        } else {
            $query->orderByDesc('created_at');
        }

        return response()->json([
            'data' => ForumThreadResource::collection($query->limit(50)->get()),
        ]);
    }

    public function show(string $id)
    {
        $thread = ForumThread::with(['replies' => function ($query) {
            $query->orderBy('created_at');
        }])->findOrFail($id);

        return response()->json(['data' => new ForumThreadResource($thread)]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'title' => ['required', 'string', 'max:200'],
            'body' => ['nullable', 'string'],
            'category' => ['required', 'string'],
            'is_anonymous' => ['boolean'],
            'tags' => ['nullable', 'array'],
        ]);

        $thread = ForumThread::create([
            'user_id' => $request->user()->id,
            'title' => $data['title'],
            'body' => $data['body'] ?? null,
            'category' => $data['category'],
            'is_anonymous' => $data['is_anonymous'] ?? false,
            'tags' => $data['tags'] ?? [],
            'status' => 'open',
        ]);

        return response()->json(['data' => new ForumThreadResource($thread)], 201);
    }

    public function reply(Request $request, string $id)
    {
        $data = $request->validate([
            'body' => ['required', 'string'],
        ]);

        $thread = ForumThread::findOrFail($id);
        if ($thread->is_locked) {
            return response()->json(['message' => 'Thread terkunci.'], 403);
        }

        $reply = DB::transaction(function () use ($request, $thread, $data) {
            $reply = ForumReply::create([
                'thread_id' => $thread->id,
                'user_id' => $request->user()->id,
                'body' => $data['body'],
            ]);

            $thread->increment('reply_count');

            return $reply;
        });

        return response()->json(['data' => new ForumReplyResource($reply)], 201);
    }

    public function replyToThread(Request $request)
    {
        $data = $request->validate([
            'thread_id' => ['required', 'string'],
            'body' => ['required', 'string'],
        ]);

        return $this->reply($request, $data['thread_id']);
    }

    public function likeThread(Request $request, string $id)
    {
        return $this->toggleLike($request, 'thread', $id);
    }

    public function likeReply(Request $request, string $id)
    {
        return $this->toggleLike($request, 'reply', $id);
    }

    private function toggleLike(Request $request, string $type, string $targetId)
    {
        $userId = $request->user()->id;

        $existing = ForumLike::where('user_id', $userId)
            ->where('target_type', $type)
            ->where('target_id', $targetId)
            ->first();

        if ($existing) {
            $existing->delete();
            $this->adjustLikeCount($type, $targetId, -1);
            return response()->json(['liked' => false]);
        }

        ForumLike::create([
            'user_id' => $userId,
            'target_type' => $type,
            'target_id' => $targetId,
        ]);
        $this->adjustLikeCount($type, $targetId, 1);

        return response()->json(['liked' => true]);
    }

    private function adjustLikeCount(string $type, string $targetId, int $delta): void
    {
        if ($type === 'thread') {
            ForumThread::where('id', $targetId)->increment('like_count', $delta);
            return;
        }

        ForumReply::where('id', $targetId)->increment('like_count', $delta);
    }

    public function update(Request $request, string $id)
    {
        $thread = ForumThread::where('user_id', $request->user()->id)->findOrFail($id);
        $data = $request->validate([
            'title' => ['sometimes', 'string'],
            'body' => ['nullable', 'string'],
            'category' => ['sometimes', 'string'],
            'tags' => ['nullable', 'array'],
            'status' => ['nullable', 'string'],
        ]);

        $thread->fill($data)->save();

        return response()->json(['data' => $thread]);
    }

    public function deleteReply(Request $request, string $id)
    {
        $reply = ForumReply::findOrFail($id);
        $thread = ForumThread::find($reply->thread_id);
        $reply->delete();

        if ($thread) {
            $thread->decrement('reply_count');
        }

        return response()->json(['message' => 'Balasan dihapus.']);
    }

    public function moderate(Request $request, string $id)
    {
        $data = $request->validate([
            'is_hidden' => ['nullable', 'boolean'],
            'is_locked' => ['nullable', 'boolean'],
        ]);

        $thread = ForumThread::findOrFail($id);
        $thread->fill($data)->save();

        return response()->json(['data' => $thread]);
    }
}
