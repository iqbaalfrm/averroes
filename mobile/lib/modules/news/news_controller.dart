import 'package:get/get.dart';

import '../../config/env_config.dart';
import 'news_dummy_data.dart';
import 'news_models.dart';
import 'news_repository.dart';

class NewsController extends GetxController {
  final NewsRepository _repository = NewsRepository();

  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<NewsItem> items = <NewsItem>[].obs;
  final RxBool hasMore = true.obs;

  static const int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    loadLatest();
  }

  Future<void> loadLatest() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final latest = await _repository.getLatest(limit: 5);
      if (latest.isNotEmpty) {
        items.assignAll(latest);
      } else if (!EnvConfig.isProduction) {
        items.assignAll(newsDummyItems);
      } else {
        items.clear();
      }
    } catch (e) {
      if (!EnvConfig.isProduction) {
        items.assignAll(newsDummyItems);
      } else {
        items.clear();
      }
      errorMessage.value = 'Gagal memuat berita.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadInitialPage() async {
    isLoading.value = true;
    errorMessage.value = '';
    hasMore.value = true;

    try {
      final page = await _repository.getPage(limit: pageSize, offset: 0);
      if (page.isNotEmpty) {
        items.assignAll(page);
        hasMore.value = page.length == pageSize;
      } else if (!EnvConfig.isProduction) {
        items.assignAll(newsDummyItems);
        hasMore.value = false;
      } else {
        items.clear();
        hasMore.value = false;
      }
    } catch (e) {
      if (!EnvConfig.isProduction) {
        items.assignAll(newsDummyItems);
      } else {
        items.clear();
      }
      hasMore.value = false;
      errorMessage.value = 'Gagal memuat berita.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      final page = await _repository.getPage(
        limit: pageSize,
        offset: items.length,
      );
      if (page.isNotEmpty) {
        items.addAll(page);
        hasMore.value = page.length == pageSize;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      hasMore.value = false;
    } finally {
      isLoadingMore.value = false;
    }
  }
}
