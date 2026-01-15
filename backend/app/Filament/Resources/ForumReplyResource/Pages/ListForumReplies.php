<?php

namespace App\Filament\Resources\ForumReplyResource\Pages;

use App\Filament\Resources\ForumReplyResource;
use Filament\Resources\Pages\ListRecords;
use Filament\Resources\Pages\EditRecord;

class ListForumReplies extends ListRecords
{
    protected static string $resource = ForumReplyResource::class;
}

class EditForumReply extends EditRecord
{
    protected static string $resource = ForumReplyResource::class;
}
