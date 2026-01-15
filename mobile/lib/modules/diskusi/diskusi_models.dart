import 'package:flutter/material.dart';

class DiskusiUser {
  final String id;
  final String name;
  final bool isAnonymous;

  const DiskusiUser({
    required this.id,
    required this.name,
    this.isAnonymous = false,
  });

  String get displayName => isAnonymous ? 'Anonim' : name;
}

class DiskusiReply {
  final String id;
  final String threadId;
  final DiskusiUser author;
  final String content;
  final DateTime createdAt;
  int helpfulCount;
  bool isAccepted;

  DiskusiReply({
    required this.id,
    required this.threadId,
    required this.author,
    required this.content,
    required this.createdAt,
    this.helpfulCount = 0,
    this.isAccepted = false,
  });
}

class DiskusiThread {
  final String id;
  final String title;
  final String description;
  final String category;
  final DiskusiUser author;
  final DateTime createdAt;
  final List<DiskusiReply> replies;
  bool isAnswered;
  bool isModerated;
  int helpfulCount;
  int replyCount;
  bool isLocal;

  DiskusiThread({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.author,
    required this.createdAt,
    List<DiskusiReply>? replies,
    this.isAnswered = false,
    this.isModerated = false,
    this.helpfulCount = 0,
    int? replyCount,
    this.isLocal = false,
  })  : replies = replies ?? [],
        replyCount = replyCount ?? (replies?.length ?? 0);
}

class DiskusiCategory {
  final String label;
  final IconData icon;
  final Color color;

  const DiskusiCategory({
    required this.label,
    required this.icon,
    required this.color,
  });
}
