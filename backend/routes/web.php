<?php

use Illuminate\Support\Facades\Route;
use Dedoc\Scramble\Scramble;

Route::get('/login', function () {
    return redirect()->route('filament.admin.auth.login');
})->name('login');

Scramble::routes(fn (\Illuminate\Routing\Route $route) => str_starts_with($route->uri, 'api'));

Route::get('/', function () {
    return view('welcome');
});
