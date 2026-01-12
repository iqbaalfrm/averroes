import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../services/location_service.dart';
import '../../services/prayer_times_service.dart';
import '../../services/notification_service.dart';

/// =============================================================================
/// PRAYER TIMES CONTROLLER - GetX Controller
/// =============================================================================
/// 
/// Mengelola:
/// - State loading/error
/// - Fetch jadwal sholat berdasarkan lokasi
/// - Countdown ke waktu sholat berikutnya
/// - Schedule notifikasi
/// =============================================================================

class PrayerTimesController extends GetxController {
  // Services
  final LocationService _locationService = LocationService();
  final PrayerTimesService _prayerService = PrayerTimesService();
  final NotificationService _notificationService = NotificationService();

  // Observable State
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final errorType = LocationResultStatus.success.obs;

  // Prayer Times Data
  final Rx<PrayerTimesData?> prayerData = Rx<PrayerTimesData?>(null);
  
  // Next Prayer
  final nextPrayerName = 'Subuh'.obs;
  final nextPrayerTime = DateTime.now().obs;
  final countdown = '00:00:00'.obs;

  // Location
  final locationName = 'Memuat...'.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;

  // Timer
  Timer? _countdownTimer;
  String? _currentDate;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    super.onClose();
  }

  /// Initialize controller
  Future<void> _initialize() async {
    await _notificationService.init();
    await _notificationService.requestPermission();
    await fetchPrayerTimes();
    _startDayChangeChecker();
  }

  /// Fetch prayer times based on location
  Future<void> fetchPrayerTimes() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Get location
      final locationResult = await _locationService.getCurrentPosition();
      
      if (!locationResult.isSuccess) {
        _handleLocationError(locationResult);
        return;
      }

      latitude.value = locationResult.latitude;
      longitude.value = locationResult.longitude;
      locationName.value = 'Indonesia';

      // Fetch prayer times
      final data = await _prayerService.getPrayerTimes(
        latitude: locationResult.latitude,
        longitude: locationResult.longitude,
      );

      prayerData.value = data;
      _currentDate = data.dateString;

      // Compute next prayer
      _updateNextPrayer();

      // Start countdown timer
      _startCountdownTimer();

      // Schedule notifications
      await _schedulePrayerNotifications();

      isLoading.value = false;
      hasError.value = false;

      print('🕌 [Prayer] Fetched successfully');
    } catch (e) {
      print('❌ [Prayer] Error: $e');
      isLoading.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
      errorType.value = LocationResultStatus.error;
    }
  }

  /// Handle location errors
  void _handleLocationError(LocationResult result) {
    isLoading.value = false;
    hasError.value = true;
    errorMessage.value = result.errorMessage ?? 'Gagal mendapatkan lokasi';
    errorType.value = result.status;
    locationName.value = 'Lokasi tidak tersedia';
  }

  /// Update next prayer info
  void _updateNextPrayer() {
    final data = prayerData.value;
    if (data == null) return;

    final next = data.getNextPrayer();
    if (next != null) {
      nextPrayerName.value = next.key;
      nextPrayerTime.value = next.value;
    }
  }

  /// Start countdown timer (1 second interval)
  void _startCountdownTimer() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
      _checkDayChange();
    });

    // Initial update
    _updateCountdown();
  }

  /// Update countdown display
  void _updateCountdown() {
    final now = DateTime.now();
    final target = nextPrayerTime.value;
    
    if (target.isBefore(now)) {
      // Next prayer passed, update to next one
      _updateNextPrayer();
      return;
    }

    final diff = target.difference(now);
    
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    countdown.value = '${_pad(hours)}:${_pad(minutes)}:${_pad(seconds)}';
  }

  String _pad(int value) => value.toString().padLeft(2, '0');

  /// Check if day changed and refetch
  void _checkDayChange() {
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    if (_currentDate != null && _currentDate != today) {
      print('🕌 [Prayer] Day changed, refetching...');
      fetchPrayerTimes();
    }
  }

  /// Start day change checker (midnight)
  void _startDayChangeChecker() {
    // Calculate time until midnight
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final duration = midnight.difference(now);

    Future.delayed(duration, () {
      fetchPrayerTimes();
      _startDayChangeChecker(); // Restart for next day
    });
  }

  /// Schedule prayer notifications
  Future<void> _schedulePrayerNotifications() async {
    final data = prayerData.value;
    if (data == null) return;

    await _notificationService.schedulePrayerNotifications(
      prayerTimes: data.allPrayers,
    );
  }

  /// Retry after error
  Future<void> retry() async {
    await fetchPrayerTimes();
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await _locationService.openLocationSettings();
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    await _locationService.openAppSettings();
  }

  // =========================================================================
  // GETTERS
  // =========================================================================

  /// Get formatted next prayer time (e.g., "04:32")
  String get nextPrayerTimeFormatted {
    return DateFormat('HH:mm').format(nextPrayerTime.value);
  }

  /// Get all prayer times formatted
  Map<String, String> get allPrayerTimesFormatted {
    final data = prayerData.value;
    if (data == null) return {};

    return {
      'Subuh': data.formatTime(data.fajr),
      'Syuruq': data.formatTime(data.sunrise),
      'Dzuhur': data.formatTime(data.dhuhr),
      'Ashar': data.formatTime(data.asr),
      'Maghrib': data.formatTime(data.maghrib),
      'Isya': data.formatTime(data.isha),
    };
  }

  /// Get current prayer name
  String get currentPrayerName {
    final data = prayerData.value;
    if (data == null) return '';
    return data.getCurrentPrayer()?.key ?? '';
  }
}
