import 'package:get/get.dart';

class BerandaController extends GetxController {
  final RxBool isLoading = true.obs;

  // Prayer times dummy data - Indonesia (Jakarta)
  final Map<String, String> prayerTimesIndonesia = {
    'Subuh': '04:32',
    'Dzuhur': '11:54',
    'Ashar': '15:12',
    'Maghrib': '18:02',
    'Isya': '19:14',
  };

  // Prayer times dummy data - Arab Saudi (Makkah)
  final Map<String, String> prayerTimesMakkah = {
    'Subuh': '05:42',
    'Dzuhur': '12:28',
    'Ashar': '15:45',
    'Maghrib': '18:15',
    'Isya': '19:45',
  };

  @override
  void onInit() {
    super.onInit();
    // Simulate loading for smooth transition
    Future.delayed(const Duration(milliseconds: 400), () {
      isLoading.value = false;
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 3 && hour < 12) {
      return 'Selamat Pagi';
    } else if (hour >= 12 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  String getCurrentPrayer() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) {
      return 'Dzuhur';
    } else if (hour >= 12 && hour < 15) {
      return 'Ashar';
    } else if (hour >= 15 && hour < 18) {
      return 'Maghrib';
    } else if (hour >= 18 && hour < 20) {
      return 'Isya';
    } else {
      return 'Subuh';
    }
  }
}
