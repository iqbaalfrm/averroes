import 'package:get/get.dart';

import '../../services/app_session_controller.dart';
import '../../services/auth_guard.dart';
import '../../widgets/custom_dialog.dart';
import 'pustaka_dummy_data.dart';
import 'pustaka_models.dart';
import 'pustaka_repository.dart';

class PustakaController extends GetxController {
  final PustakaRepository _repository = PustakaRepository();
  final AppSessionController _session = Get.find<AppSessionController>();

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedCategory = 'Semua'.obs;

  final RxList<BookModel> books = <BookModel>[].obs;
  final RxSet<String> bookmarkedIds = <String>{}.obs;
  final RxMap<String, BookProgress> progressMap =
      <String, BookProgress>{}.obs;

  final List<String> categories = [
    'Semua',
    'Fiqh Muamalah',
    'Crypto Syariah',
    'Ekonomi Islam',
    'Referensi Ulama',
  ];

  @override
  void onInit() {
    super.onInit();
    loadBooks();
    ever(_session.isAuthenticated, (_) => _loadUserData());
  }

  List<BookModel> get filteredBooks {
    if (selectedCategory.value == 'Semua') return books;
    return books.where((book) => book.category == selectedCategory.value).toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  bool isBookmarked(String bookId) => bookmarkedIds.contains(bookId);

  BookProgress? getProgress(String bookId) => progressMap[bookId];

  Future<void> loadBooks() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final remoteBooks = await _repository.fetchBooks();
      if (remoteBooks.isNotEmpty) {
        books.assignAll(remoteBooks);
      } else {
        books.assignAll(pustakaDummyBooks);
      }
    } catch (e) {
      books.assignAll(pustakaDummyBooks);
      errorMessage.value = 'Tidak bisa memuat data pustaka.';
    } finally {
      isLoading.value = false;
    }

    await _loadUserData();
  }

  Future<String?> resolvePdfUrl(BookModel book) async {
    return _repository.resolvePdfUrl(book.pdfUrl);
  }

  Future<void> toggleBookmark(BookModel book) async {
    AuthGuard.requireAuth(
      featureName: 'Bookmark',
      onAllowed: () async {
        final userId = _session.userId.value;
        if (userId == null) return;

        final alreadyBookmarked = isBookmarked(book.id);
        try {
          if (alreadyBookmarked) {
            await _repository.removeBookmark(userId, book.id);
            bookmarkedIds.remove(book.id);
          } else {
            await _repository.addBookmark(userId, book.id);
            bookmarkedIds.add(book.id);
          }
        } catch (e) {
          AppDialogs.showError(
            title: 'Gagal',
            message: 'Bookmark belum tersimpan. Coba lagi.',
          );
        }
      },
    );
  }

  Future<void> markAsRead(BookModel book) async {
    AuthGuard.requireAuth(
      featureName: 'Simpan progres',
      onAllowed: () async {
        final userId = _session.userId.value;
        if (userId == null) return;

        final pageCount = book.pages ?? 1;
        try {
          await _repository.upsertProgress(
            userId: userId,
            bookId: book.id,
            lastPage: pageCount,
            pageCount: pageCount,
          );
          progressMap[book.id] = BookProgress(
            bookId: book.id,
            lastPage: pageCount,
            pageCount: pageCount,
          );
          AppDialogs.showSuccess(
            title: 'Tersimpan',
            message: 'Progres bacaan kamu sudah tercatat.',
          );
        } catch (e) {
          AppDialogs.showError(
            title: 'Gagal',
            message: 'Progres belum tersimpan. Coba lagi.',
          );
        }
      },
    );
  }

  Future<void> handlePageChanged({
    required String bookId,
    required int pageNumber,
    required int pageCount,
  }) async {
    if (!_session.isAuthenticated.value) return;
    final userId = _session.userId.value;
    if (userId == null || pageCount <= 0) return;

    progressMap[bookId] = BookProgress(
      bookId: bookId,
      lastPage: pageNumber,
      pageCount: pageCount,
    );

    try {
      await _repository.upsertProgress(
        userId: userId,
        bookId: bookId,
        lastPage: pageNumber,
        pageCount: pageCount,
      );
    } catch (_) {}
  }

  Future<void> _loadUserData() async {
    if (!_session.isAuthenticated.value || _session.userId.value == null) {
      bookmarkedIds.clear();
      progressMap.clear();
      return;
    }

    final userId = _session.userId.value!;

    try {
      final bookmarks = await _repository.fetchBookmarks(userId);
      bookmarkedIds.assignAll(bookmarks);
    } catch (_) {
      bookmarkedIds.clear();
    }

    try {
      final progressList = await _repository.fetchProgressForUser(userId);
      progressMap.assignAll({
        for (final progress in progressList) progress.bookId: progress,
      });
    } catch (_) {
      progressMap.clear();
    }
  }
}
