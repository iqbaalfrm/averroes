<?php

namespace App\Filament\Resources\ForumReplyResource\Pages;

use App\Filament\Resources\ForumReplyResource;
use Filament\Resources\Pages\ViewRecord;

class ViewForumReply extends ViewRecord
{
    protected static string $resource = ForumReplyResource::class;
    protected static ?string $title = 'Detail Balasan Diskusi';
    protected static ?string $breadcrumb = 'Detail';
}
