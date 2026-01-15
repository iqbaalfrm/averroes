import 'package:flutter/material.dart';

class BookModel {
  final String id;
  final String title;
  final String? titleOriginal;
  final String? titleReadable;
  final String author;
  final String language;
  final String category;
  final int? pages;
  final String description;
  final String? pdfUrl;
  final String? coverUrl;
  final bool isPremium;
  final bool isLocal;
  final Color? color;

  BookModel({
    required this.id,
    required this.title,
    this.titleOriginal,
    this.titleReadable,
    required this.author,
    required this.language,
    required this.category,
    this.pages,
    required this.description,
    this.pdfUrl,
    this.coverUrl,
    this.isPremium = false,
    this.isLocal = false,
    this.color,
  });
}

class BookProgress {
  final String bookId;
  final int lastPage;
  final int pageCount;

  BookProgress({
    required this.bookId,
    required this.lastPage,
    required this.pageCount,
  });
}
