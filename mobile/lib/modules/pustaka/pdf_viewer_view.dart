import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../theme/app_theme.dart';

class PdfViewerView extends StatefulWidget {
  final String title;
  final String pdfUrl;
  final int? initialPage;
  final void Function(int pageNumber, int pageCount)? onPageChanged;

  const PdfViewerView({
    super.key,
    required this.title,
    required this.pdfUrl,
    this.initialPage,
    this.onPageChanged,
  });

  @override
  State<PdfViewerView> createState() => _PdfViewerViewState();
}

class _PdfViewerViewState extends State<PdfViewerView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _pageCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 18,
              color: MuamalahColors.textPrimary,
            ),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: MuamalahColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MuamalahColors.neutralBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.bookmark_outline_rounded,
                size: 18,
                color: MuamalahColors.textPrimary,
              ),
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError)
            SfPdfViewer.network(
              widget.pdfUrl,
              key: _pdfViewerKey,
              controller: _pdfViewerController,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              enableDoubleTapZooming: true,
              onDocumentLoaded: (details) {
                setState(() {
                  _isLoading = false;
                  _pageCount = details.document.pages.count;
                });
                if (widget.initialPage != null &&
                    widget.initialPage! > 0 &&
                    widget.initialPage! <= _pageCount) {
                  _pdfViewerController.jumpToPage(widget.initialPage!);
                }
              },
              onDocumentLoadFailed: (details) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                  _errorMessage = details.description;
                });
              },
              onPageChanged: (details) {
                widget.onPageChanged?.call(details.newPageNumber, _pageCount);
              },
            ),

          if (_isLoading && !_hasError)
            Container(
              color: MuamalahColors.backgroundPrimary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: MuamalahColors.primaryEmerald,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Memuat Dokumen...',
                      style: TextStyle(
                        fontSize: 14,
                        color: MuamalahColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Mengunduh PDF dari server',
                      style: TextStyle(
                        fontSize: 12,
                        color: MuamalahColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_hasError)
            Container(
              color: MuamalahColors.backgroundPrimary,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: MuamalahColors.haramBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: MuamalahColors.haram,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Gagal Memuat PDF',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MuamalahColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage.isNotEmpty
                            ? _errorMessage
                            : 'Terjadi kesalahan saat mengunduh dokumen. Periksa koneksi internet Anda.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: MuamalahColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLoading = true;
                            _hasError = false;
                            _errorMessage = '';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: MuamalahColors.primaryEmerald,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: MuamalahColors.primaryEmerald.withAlpha(77),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Coba Lagi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
