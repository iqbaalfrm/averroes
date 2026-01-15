/// =============================================================================
/// NEWS HELPERS
/// =============================================================================
/// Helper functions untuk parsing dan formatting artikel
/// =============================================================================

/// Strip HTML tags dari string
String stripHtml(String html) {
  final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  return html.replaceAll(exp, '').trim();
}

/// Format relative time (Indonesian)
String relativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 7) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} hari lalu';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} jam lalu';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} menit lalu';
  } else {
    return 'Baru saja';
  }
}

/// Truncate text dengan ellipsis
String truncate(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}

/// Parse Google News redirect URL untuk mendapatkan original URL
String? extractOriginalUrl(String googleNewsUrl) {
  try {
    final uri = Uri.parse(googleNewsUrl);
    
    // Check if it's a Google News URL
    if (!googleNewsUrl.contains('news.google.com')) {
      return googleNewsUrl; // Already original URL
    }
    
    // Try to extract from query params
    final url = uri.queryParameters['url'];
    if (url != null && url.isNotEmpty) {
      return Uri.decodeComponent(url);
    }
    
    // If cannot extract, return the Google News URL
    return googleNewsUrl;
  } catch (e) {
    return googleNewsUrl;
  }
}
