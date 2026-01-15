import 'package:get/get.dart';

import '../../services/app_session_controller.dart';
import '../../config/env_config.dart';
import 'diskusi_dummy_data.dart';
import 'diskusi_models.dart';
import 'diskusi_repository.dart';

class DiskusiController extends GetxController {
  final AppSessionController sessionController = Get.find<AppSessionController>();
  final DiskusiRepository _repository = DiskusiRepository();

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<DiskusiThread> threads = <DiskusiThread>[].obs;
  final RxString activeTab = 'Terbaru'.obs;
  final RxString lastReplyId = ''.obs;
  final RxString lastThreadId = ''.obs;

  final Map<String, RxList<DiskusiReply>> repliesByThread = {};

  final List<String> tabs = const ['Terbaru', 'Populer', 'Belum Terjawab'];

  @override
  void onInit() {
    super.onInit();
    loadThreads();
  }

  Future<void> loadThreads() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final remoteThreads = await _repository.fetchThreads();
      if (remoteThreads.isNotEmpty) {
        threads.assignAll(remoteThreads);
      } else if (sessionController.isDemoMode.value && !EnvConfig.isProduction) {
        threads.assignAll(buildDiskusiDummyThreads());
      } else {
        threads.clear();
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat diskusi.';
      if (sessionController.isDemoMode.value && !EnvConfig.isProduction) {
        threads.assignAll(buildDiskusiDummyThreads());
      } else {
        threads.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<DiskusiThread> get filteredThreads {
    final items = threads.toList();
    switch (activeTab.value) {
      case 'Populer':
        items.sort((a, b) => _scoreThread(b).compareTo(_scoreThread(a)));
        return items;
      case 'Belum Terjawab':
        return items.where((item) => !item.isAnswered).toList();
      default:
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return items;
    }
  }

  int _scoreThread(DiskusiThread thread) {
    final replyScore = thread.replyCount * 3;
    return replyScore + thread.helpfulCount;
  }

  RxList<DiskusiReply> repliesFor(String threadId) {
    return repliesByThread.putIfAbsent(threadId, () => <DiskusiReply>[].obs);
  }

  Future<void> loadReplies(DiskusiThread thread) async {
    final list = repliesFor(thread.id);
    if (thread.isLocal) {
      list.assignAll(thread.replies);
      return;
    }
    try {
      final replies = await _repository.fetchReplies(thread.id);
      if (replies.isEmpty && thread.replies.isNotEmpty) {
        list.assignAll(thread.replies);
      } else {
        list.assignAll(replies);
      }
    } catch (_) {
      if (thread.replies.isNotEmpty) {
        list.assignAll(thread.replies);
      }
    }
  }

  DiskusiUser currentUser({bool anonymous = false}) {
    if (sessionController.isGuest.value) {
      return const DiskusiUser(id: 'guest', name: 'Tamu', isAnonymous: true);
    }
    final userId = sessionController.userId.value ?? 'user';
    final name = sessionController.displayName;
    return DiskusiUser(id: userId, name: name, isAnonymous: anonymous);
  }

  bool isOwner(DiskusiThread thread) {
    final current = currentUser();
    return thread.author.id == current.id;
  }

  bool isBlockedContent(String text) {
    final lowered = text.toLowerCase();
    const blockedPhrases = [
      'prediksi harga',
      'target price',
      'pump',
      'signal',
      'entry',
      'tp ',
      'take profit',
      'to the moon',
      'pompa',
    ];
    return blockedPhrases.any((phrase) => lowered.contains(phrase));
  }

  Future<bool> addThread({
    required String title,
    required String description,
    required String category,
    required bool anonymous,
  }) async {
    if (isBlockedContent('$title $description')) {
      return false;
    }

    final user = currentUser(anonymous: anonymous);
    DiskusiThread? thread;

    if (!sessionController.isGuest.value) {
      try {
        thread = await _repository.createThread(
          userId: user.id,
          isAnonymous: anonymous,
          category: category,
          title: title,
          body: description,
        );
      } catch (_) {
        thread = null;
      }
    }

    thread ??= DiskusiThread(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      author: user,
      createdAt: DateTime.now(),
      replies: [],
      isAnswered: false,
      helpfulCount: 0,
      isLocal: true,
    );

    threads.insert(0, thread);
    lastThreadId.value = thread.id;
    return true;
  }

  Future<bool> addReply({
    required DiskusiThread thread,
    required String content,
  }) async {
    if (isBlockedContent(content)) {
      return false;
    }

    final list = repliesFor(thread.id);
    DiskusiReply? reply;

    if (!sessionController.isGuest.value && !thread.isLocal) {
      try {
        reply = await _repository.createReply(
          threadId: thread.id,
          userId: currentUser().id,
          body: content,
        );
      } catch (_) {
        reply = null;
      }
    }

    reply ??= DiskusiReply(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      threadId: thread.id,
      author: currentUser(),
      content: content,
      createdAt: DateTime.now(),
      helpfulCount: 0,
    );

    list.add(reply);
    lastReplyId.value = reply.id;
    thread.replyCount += 1;
    threads.refresh();
    return true;
  }

  Future<void> toggleReplyLike(DiskusiReply reply) async {
    reply.helpfulCount += 1;
    threads.refresh();

    if (sessionController.isGuest.value) {
      return;
    }

    final result = await _repository.toggleLike(
      userId: currentUser().id,
      targetType: 'reply',
      targetId: reply.id,
    );

    if (result == false) {
      reply.helpfulCount = (reply.helpfulCount - 1).clamp(0, 999999);
      threads.refresh();
    }
  }

  Future<void> toggleThreadLike(DiskusiThread thread) async {
    thread.helpfulCount += 1;
    threads.refresh();

    if (sessionController.isGuest.value || thread.isLocal) {
      return;
    }

    final result = await _repository.toggleLike(
      userId: currentUser().id,
      targetType: 'thread',
      targetId: thread.id,
    );

    if (result == false) {
      thread.helpfulCount = (thread.helpfulCount - 1).clamp(0, 999999);
      threads.refresh();
    }
  }

  Future<void> markAccepted(DiskusiThread thread, DiskusiReply reply) async {
    for (final item in repliesFor(thread.id)) {
      item.isAccepted = false;
    }
    reply.isAccepted = true;
    thread.isAnswered = true;
    threads.refresh();

    if (!thread.isLocal && !sessionController.isGuest.value) {
      await _repository.markAccepted(threadId: thread.id, replyId: reply.id);
    }
  }
}
