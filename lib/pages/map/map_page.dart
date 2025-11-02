// lib/pages/map/map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '/services/loc.dart';
import '/config/theme.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  
  Position? _currentPosition;
  List<Marker> _markers = [];
  
  bool _isLoading = true;
  bool _isLoadingLocation = false;
  String? _errorMessage;

  // Default location (Jakarta)
  final LatLng _defaultLocation = LatLng(-6.2088, 106.8456);
  
  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    try {
      await _loadAotLocations();
    } catch (e) {
      print('Error loading locations: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load locations.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadAotLocations() async {
    final locations = AotLocation.getAllLocations();
    
    for (var location in locations) {
      _markers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(location.latitude, location.longitude),
          child: GestureDetector(
            onTap: () => _showLocationDetails(location),
            child: Container(
              decoration: BoxDecoration(
                color: _getTypeColor(location.type),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _getTypeIcon(location.type),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }
    
    if (mounted) setState(() {});
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'wall':
        return Icons.shield;
      case 'district':
        return Icons.location_city;
      case 'base':
        return Icons.military_tech;
      default:
        return Icons.place;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'wall':
        return AppTheme.accentColor;
      case 'district':
        return AppTheme.warningColor;
      case 'base':
        return AppTheme.successColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    final result = await _locationService.handlePermissionAndGetLocation();

    if (result['success']) {
      _currentPosition = result['position'];
      
      // Add current location marker
      _markers.add(
        Marker(
          width: 50,
          height: 50,
          point: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      );

      // Move map to current location
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        12.0,
      );
    } else {
      _errorMessage = result['message'];
    }

    setState(() => _isLoadingLocation = false);
  }

  void _showLocationDetails(AotLocation location) {
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildLocationBottomSheet(location),
    );
  }

  Widget _buildLocationBottomSheet(AotLocation location) {
    final distance = _locationService.calculateDistanceToLocation(location);
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Type badge
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getTypeColor(location.type),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getTypeIcon(location.type),
                  color: _getTypeColor(location.type),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getTypeColor(location.type),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  location.type.toUpperCase(),
                  style: AppTheme.caption.copyWith(
                    color: _getTypeColor(location.type),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Location name
          Text(
            location.name,
            style: AppTheme.headingMedium,
          ),
          
          SizedBox(height: 8),
          
          // Description
          Text(
            location.description,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textColor,
            ),
          ),
          
          SizedBox(height: 16),
          
          // Distance
          if (distance != null) ...[
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.navigation, 
                    size: 20, 
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Distance from you: ${_locationService.formatDistance(distance)}',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
          
          // Coordinates
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latitude', style: AppTheme.caption),
                    SizedBox(height: 2),
                    Text(
                      location.latitude.toStringAsFixed(4),
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Longitude', style: AppTheme.caption),
                    SizedBox(height: 2),
                    Text(
                      location.longitude.toStringAsFixed(4),
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          // Navigate button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _navigateToLocation(location);
              },
              icon: Icon(Icons.explore),
              label: Text('Explore Location'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _navigateToLocation(AotLocation location) {
    _mapController.move(
      LatLng(location.latitude, location.longitude),
      15.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Flutter Map (OpenStreetMap)
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : _defaultLocation,
              initialZoom: 11.0,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              // Tile Layer (Map tiles from OpenStreetMap)
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.aot.scout_regiment',
                maxNativeZoom: 19,
              ),
              
              // Markers Layer
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
          
          // Top info card
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildTopInfoCard(),
          ),
          
          // Floating action buttons
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                // My location button
                FloatingActionButton(
                  heroTag: 'my_location',
                  onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                  backgroundColor: AppTheme.backgroundColor,
                  child: _isLoadingLocation
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.my_location, color: AppTheme.primaryColor),
                ),
                
                SizedBox(height: 12),
                
                // Legend button
                FloatingActionButton(
                  heroTag: 'legend',
                  onPressed: _showLegend,
                  backgroundColor: AppTheme.primaryColor,
                  child: Icon(Icons.info_outline),
                ),
              ],
            ),
          ),
          
          // Error message
          if (_errorMessage != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 20),
                      onPressed: () => setState(() => _errorMessage = null),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.map,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Survey Corps Map',
                      style: AppTheme.headingSmall,
                    ),
                    Text(
                      'Explore Attack on Titan locations',
                      style: AppTheme.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${AotLocation.getAllLocations().length} locations discovered',
              style: AppTheme.caption.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLegend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.legend_toggle, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('Map Legend'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegendItem(Icons.shield, 'Walls', AppTheme.accentColor),
            SizedBox(height: 12),
            _buildLegendItem(Icons.location_city, 'Districts', AppTheme.warningColor),
            SizedBox(height: 12),
            _buildLegendItem(Icons.military_tech, 'Military Bases', AppTheme.successColor),
            SizedBox(height: 12),
            _buildLegendItem(Icons.person_pin_circle, 'Your Location', Colors.blue),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTheme.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}