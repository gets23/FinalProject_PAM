// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  // ============= PERMISSION HANDLING =============

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Handle permission and get location
  Future<Map<String, dynamic>> handlePermissionAndGetLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        'success': false,
        'message': 'Location services are disabled. Please enable GPS.',
      };
    }

    // Check permission
    LocationPermission permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          'success': false,
          'message': 'Location permission denied.',
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        'success': false,
        'message': 'Location permission permanently denied. Please enable in settings.',
      };
    }

    // Get location
    try {
      final position = await getCurrentLocation();
      return {
        'success': true,
        'position': position,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to get location: ${e.toString()}',
      };
    }
  }

  // ============= GET LOCATION =============

  /// Get current location
  Future<Position> getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      return _currentPosition!;
    } catch (e) {
      throw Exception('Failed to get location: ${e.toString()}');
    }
  }

  /// Get last known location (faster but might be outdated)
  Future<Position?> getLastKnownLocation() async {
    return await Geolocator.getLastKnownPosition();
  }

  // ============= LOCATION STREAM =============

  /// Stream location updates
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  // ============= DISTANCE CALCULATION =============

  /// Calculate distance between two coordinates (in meters)
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Calculate distance to AOT location
  double? calculateDistanceToLocation(AotLocation location) {
    if (_currentPosition == null) return null;

    return calculateDistance(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      location.latitude,
      location.longitude,
    );
  }

  /// Format distance to readable string
  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
  }

  // ============= OPEN SETTINGS =============

  /// Open app settings (for enabling location permission)
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}

// ============= AOT LOCATION MODEL =============

class AotLocation {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String type; // 'wall', 'district', 'base'
  final String? imageUrl;

  AotLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.imageUrl,
  });

  // Predefined AOT Locations (fictional but mapped to real-world coordinates)
  static List<AotLocation> getAllLocations() {
    return [
      // Walls
      AotLocation(
        id: 'wall_maria',
        name: 'Wall Maria',
        description: 'Outermost wall of humanity. Breached in Year 845.',
        latitude: -6.2088, // Jakarta area
        longitude: 106.8456,
        type: 'wall',
      ),
      AotLocation(
        id: 'wall_rose',
        name: 'Wall Rose',
        description: 'Second protective wall. Agricultural center.',
        latitude: -6.1751,
        longitude: 106.8650,
        type: 'wall',
      ),
      AotLocation(
        id: 'wall_sina',
        name: 'Wall Sina',
        description: 'Innermost wall. Home of the royal capital.',
        latitude: -6.1944,
        longitude: 106.8229,
        type: 'wall',
      ),

      // Districts
      AotLocation(
        id: 'shiganshina',
        name: 'Shiganshina District',
        description: 'Hometown of Eren Yeager. First district to fall.',
        latitude: -6.2297,
        longitude: 106.8540,
        type: 'district',
      ),
      AotLocation(
        id: 'trost',
        name: 'Trost District',
        description: 'Strategic gateway to Wall Rose.',
        latitude: -6.1858,
        longitude: 106.8650,
        type: 'district',
      ),
      AotLocation(
        id: 'stohess',
        name: 'Stohess District',
        description: 'District within Wall Sina. Site of Annie vs Eren battle.',
        latitude: -6.1862,
        longitude: 106.8070,
        type: 'district',
      ),

      // Military Bases
      AotLocation(
        id: 'training_corps',
        name: 'Training Corps HQ',
        description: '104th Training Corps headquarters.',
        latitude: -6.2000,
        longitude: 106.8500,
        type: 'base',
      ),
      AotLocation(
        id: 'survey_corps_hq',
        name: 'Survey Corps HQ',
        description: 'Headquarters of the Survey Corps (Scouting Legion).',
        latitude: -6.1700,
        longitude: 106.8300,
        type: 'base',
      ),
      AotLocation(
        id: 'garrison_hq',
        name: 'Garrison HQ',
        description: 'Headquarters of the Garrison Regiment.',
        latitude: -6.1900,
        longitude: 106.8400,
        type: 'base',
      ),
    ];
  }

  // Get location by ID
  static AotLocation? getLocationById(String id) {
    try {
      return getAllLocations().firstWhere((loc) => loc.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get locations by type
  static List<AotLocation> getLocationsByType(String type) {
    return getAllLocations().where((loc) => loc.type == type).toList();
  }
}