import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class OsmMapView extends StatefulWidget {
  const OsmMapView({
    super.key,
    this.initialZoom = 15,
    this.fallbackCenter = const LatLng(37.7749, -122.4194),
    this.centerOverride,
    this.polylinePoints,
    this.enableLocationTracking = true,
    this.followUser = true,
  });

  final double initialZoom;
  final LatLng fallbackCenter;
  final LatLng? centerOverride;
  final List<LatLng>? polylinePoints;
  final bool enableLocationTracking;
  final bool followUser;

  @override
  State<OsmMapView> createState() => _OsmMapViewState();
}

class _OsmMapViewState extends State<OsmMapView> {
  final MapController _mapController = MapController();
  LatLng? _center;
  String? _statusMessage;
  bool _userPanning = false;

  @override
  void initState() {
    super.initState();
    if (widget.enableLocationTracking) {
      _loadLocation();
    }
  }

  @override
  void didUpdateWidget(covariant OsmMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_userPanning) return;
    final override = widget.centerOverride;
    if (override != null && override != oldWidget.centerOverride) {
      _mapController.move(override, widget.initialZoom);
    } else if (widget.followUser && widget.polylinePoints != null) {
      final points = widget.polylinePoints!;
      if (points.isNotEmpty) {
        _mapController.move(points.last, widget.initialZoom);
      }
    }
  }

  Future<void> _loadLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setFallback('Location services are disabled. Showing default area.');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _setFallback('Location permission denied. Showing default area.');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      final newCenter = LatLng(position.latitude, position.longitude);
      setState(() {
        _center = newCenter;
        _statusMessage = null;
      });
      _mapController.move(newCenter, widget.initialZoom);
    } catch (_) {
      _setFallback('Unable to fetch location. Showing default area.');
    }
  }

  void _setFallback(String message) {
    if (!mounted) return;
    setState(() {
      _center = widget.fallbackCenter;
      _statusMessage = message;
    });
    _mapController.move(widget.fallbackCenter, widget.initialZoom);
  }

  void _recenter() {
    setState(() => _userPanning = false);
    final override = widget.centerOverride;
    if (override != null) {
      _mapController.move(override, widget.initialZoom);
    } else if (widget.polylinePoints != null &&
        widget.polylinePoints!.isNotEmpty) {
      _mapController.move(widget.polylinePoints!.last, widget.initialZoom);
    } else if (_center != null) {
      _mapController.move(_center!, widget.initialZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = widget.centerOverride ?? _center ?? widget.fallbackCenter;
    final polylinePoints = widget.polylinePoints;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: widget.initialZoom,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onMapEvent: (MapEvent event) {
              if (event is MapEventMoveStart && !_userPanning) {
                setState(() => _userPanning = true);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.example.bolt',
              maxZoom: 19,
            ),
            if (polylinePoints != null && polylinePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: polylinePoints,
                    strokeWidth: 4,
                    color: const Color(0xFF0088FF),
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.my_location,
                    color: Color(0xFF0088FF),
                    size: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (_statusMessage != null)
          Positioned(
            left: 16,
            right: 16,
            top: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Text(
                _statusMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
          ),
        if (_userPanning)
          Positioned(
            top: 60,
            right: 16,
            child: GestureDetector(
              onTap: _recenter,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Color(0xFF0088FF),
                  size: 22,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
