<?php

namespace App\Filament\Resources\ForumThreadResource\Pages;

use App\Filament\Resources\ForumThreadResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\EditRecord;

class ListForumThreads extends ListRecords
{
    protected static string $resource = ForumThreadResource::class;
}

class EditForumThread extends EditRecord
{
    protected static string $resource = ForumThreadResource::class;
}
