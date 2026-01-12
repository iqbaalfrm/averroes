import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'dart:io';
import '../core/domain/entities/article.dart';

class RssService {
  static const String _baseUrl = 'https://news.google.com/rss/search';

  /// Fetch articles from Google News RSS
  Future<List<Article>> fetchArticles() async {
    // Query: "Ekonomi Syariah OR Kripto Halal OR Regulasi Blockchain"
    const query = 'Ekonomi Syariah OR Kripto Halal OR Regulasi Blockchain Indonesia';
    final url = Uri.parse('$_baseUrl?q=$query&hl=id-ID&gl=ID&ceid=ID:id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return _parseRss(response.body);
      } else {
        throw Exception('Failed to load RSS: ${response.statusCode}');
      }
    } catch (e) {
      print('RSS Error: $e');
      return []; // Return empty on error
    }
  }

  List<Article> _parseRss(String xmlString) {
    try {
      final document = XmlDocument.parse(xmlString);
      final items = document.findAllElements('item');

      return items.map((node) {
        final title = node.findElements('title').single.innerText;
        final link = node.findElements('link').single.innerText;
        final pubDate = node.findElements('pubDate').single.innerText;
        String source = 'Berita';
        
        try {
           source = node.findElements('source').single.innerText;
        } catch (_) {}

        // Clean Title: "Title - Source" -> "Title"
        var cleanTitle = title;
        if (title.contains(' - ')) {
          final parts = title.split(' - ');
          if (parts.length > 1) {
            cleanTitle = parts.sublist(0, parts.length - 1).join(' - ');
            // If source tag was empty, use this
            if (source == 'Berita') source = parts.last;
          }
        }

        return Article(
          id: Article.generateId(link),
          title: cleanTitle,
          link: link,
          source: source,
          publishedAt: _parseDate(pubDate),
          snippet: null, // RSS doesn't provide good snippets
          queryTag: 'Berita',
        );
      }).toList();
    } catch (e) {
      print('XML Parse Error: $e');
      return [];
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      return HttpDate.parse(dateStr);
    } catch (e) {
      return DateTime.now();
    }
  }
}
