import 'package:geolocator/geolocator.dart';

/// =============================================================================
/// LOCATION SERVICE - Layanan Lokasi
/// =============================================================================
/// 
/// Mengelola:
/// - Request permission lokasi
/// - Get current position
/// - Handle permission denied
/// =============================================================================

class LocationService {
  // Singleton
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _lastPosition;
  
  /// Get last known position (cached)
  Position? get lastPosition => _lastPosition;

  /// Check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check current permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission;
  }

  /// Get current position with permission handling
  /// Returns null if permission denied or service disabled
  Future<LocationResult> getCurrentPosition() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.serviceDisabled();
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.permissionDenied();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult.permissionDeniedForever();
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 15),
      );

      _lastPosition = position;
      
      return LocationResult.success(position);
    } catch (e) {
      print('❌ [Location] Error: $e');
      return LocationResult.error(e.toString());
    }
  }

  /// Open app settings (for permission denied forever)
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}

// =============================================================================
// LOCATION RESULT
// =============================================================================

enum LocationResultStatus {
  success,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  error,
}

class LocationResult {
  final LocationResultStatus status;
  final Position? position;
  final String? errorMessage;

  LocationResult._({
    required this.status,
    this.position,
    this.errorMessage,
  });

  factory LocationResult.success(Position position) {
    return LocationResult._(
      status: LocationResultStatus.success,
      position: position,
    );
  }

  factory LocationResult.serviceDisabled() {
    return LocationResult._(
      status: LocationResultStatus.serviceDisabled,
      errorMessage: 'Layanan lokasi tidak aktif',
    );
  }

  factory LocationResult.permissionDenied() {
    return LocationResult._(
      status: LocationResultStatus.permissionDenied,
      errorMessage: 'Izin lokasi ditolak',
    );
  }

  factory LocationResult.permissionDeniedForever() {
    return LocationResult._(
      status: LocationResultStatus.permissionDeniedForever,
      errorMessage: 'Izin lokasi ditolak permanen',
    );
  }

  factory LocationResult.error(String message) {
    return LocationResult._(
      status: LocationResultStatus.error,
      errorMessage: message,
    );
  }

  bool get isSuccess => status == LocationResultStatus.success;
  
  double get latitude => position?.latitude ?? 0;
  double get longitude => position?.longitude ?? 0;
}
