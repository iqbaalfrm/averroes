<?php

namespace App\Filament\Resources\ArticleResource\Pages;

use App\Filament\Resources\ArticleResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\CreateRecord;
use Filament\Resources\Pages\EditRecord;

class ListArticles extends ListRecords
{
    protected static string $resource = ArticleResource::class;
}

class CreateArticle extends CreateRecord
{
    protected static string $resource = ArticleResource::class;
}

class EditArticle extends EditRecord
{
    protected static string $resource = ArticleResource::class;
}
