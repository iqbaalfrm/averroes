<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\ForumController;
use App\Http\Controllers\Api\EdukasiController;
use App\Http\Controllers\Api\BooksController;
use App\Http\Controllers\Api\PortfolioController;
use App\Http\Controllers\Api\ZakatController;
use App\Http\Controllers\Api\NewsController;
use App\Http\Controllers\Api\ScreenerController;
use App\Http\Controllers\Api\MarketController;
use App\Http\Controllers\Api\ReelsController;
use App\Http\Controllers\Api\AdminUsersController;

Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
    Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
    Route::post('reset-password', [AuthController::class, 'resetPassword']);
    Route::post('resend-verification', [AuthController::class, 'resendVerification']);
    Route::post('resend-otp', [AuthController::class, 'resendOtp']);
    Route::post('verify-otp', [AuthController::class, 'verifyOtp']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::get('me', [AuthController::class, 'me']);
        Route::post('logout', [AuthController::class, 'logout']);
    });
});

Route::get('me', [AuthController::class, 'me'])->middleware('auth:sanctum');

Route::get('articles', [NewsController::class, 'index']);
Route::get('articles/latest', [NewsController::class, 'latest']);

Route::get('screener', [ScreenerController::class, 'index']);
Route::get('market', [MarketController::class, 'index']);
Route::get('classes', [EdukasiController::class, 'index']);
Route::get('classes/{id}', [EdukasiController::class, 'show']);
Route::get('books', [BooksController::class, 'index']);
Route::get('books/{id}', [BooksController::class, 'show']);
Route::get('reels', [ReelsController::class, 'index']);

Route::prefix('forum')->group(function () {
    Route::get('threads', [ForumController::class, 'index']);
    Route::get('threads/{id}', [ForumController::class, 'show']);
});

Route::middleware('auth:sanctum')->group(function () {
    Route::get('profile', [ProfileController::class, 'show']);
    Route::patch('profile', [ProfileController::class, 'update']);

    Route::post('bookmarks', [BooksController::class, 'bookmark']);
    Route::delete('bookmarks', [BooksController::class, 'removeBookmark']);

    Route::get('classes/{id}/progress', [EdukasiController::class, 'getProgress']);
    Route::post('classes/{id}/progress', [EdukasiController::class, 'saveProgress']);

    Route::get('portfolio/assets', [PortfolioController::class, 'index']);
    Route::post('portfolio/assets', [PortfolioController::class, 'store']);
    Route::patch('portfolio/assets/{id}', [PortfolioController::class, 'update']);
    Route::delete('portfolio/assets/{id}', [PortfolioController::class, 'destroy']);

    Route::get('zakat/records', [ZakatController::class, 'index']);
    Route::post('zakat/records', [ZakatController::class, 'store']);
    Route::post('zakat/calculate', [ZakatController::class, 'calculate']);

    Route::post('forum/threads', [ForumController::class, 'store']);
    Route::post('forum/threads/{id}/replies', [ForumController::class, 'reply']);
    Route::post('forum/threads/{id}/like', [ForumController::class, 'likeThread']);
    Route::post('forum/replies/{id}/like', [ForumController::class, 'likeReply']);
    Route::patch('forum/threads/{id}', [ForumController::class, 'update']);
    Route::delete('forum/replies/{id}', [ForumController::class, 'deleteReply']);

    Route::middleware('role:admin,editor')->group(function () {
        Route::post('screener', [ScreenerController::class, 'store']);
        Route::patch('screener/{id}', [ScreenerController::class, 'update']);
        Route::delete('screener/{id}', [ScreenerController::class, 'destroy']);

        Route::post('market', [MarketController::class, 'store']);
        Route::patch('market/{id}', [MarketController::class, 'update']);
        Route::delete('market/{id}', [MarketController::class, 'destroy']);

        Route::post('classes', [EdukasiController::class, 'store']);
        Route::patch('classes/{id}', [EdukasiController::class, 'update']);
        Route::delete('classes/{id}', [EdukasiController::class, 'destroy']);

        Route::post('books', [BooksController::class, 'store']);
        Route::patch('books/{id}', [BooksController::class, 'update']);
        Route::delete('books/{id}', [BooksController::class, 'destroy']);

        Route::post('reels', [ReelsController::class, 'store']);
        Route::patch('reels/{id}', [ReelsController::class, 'update']);
        Route::delete('reels/{id}', [ReelsController::class, 'destroy']);

        Route::delete('articles/{id}', [NewsController::class, 'destroy']);
    });

    Route::middleware('role:admin,moderator')->group(function () {
        Route::patch('forum/moderate/threads/{id}', [ForumController::class, 'moderate']);
    });

    Route::middleware('role:admin')->group(function () {
        Route::get('users', [AdminUsersController::class, 'index']);
        Route::patch('users/{id}/role', [AdminUsersController::class, 'updateRole']);
        Route::patch('users/{id}/ban', [AdminUsersController::class, 'updateBan']);
    });
});
