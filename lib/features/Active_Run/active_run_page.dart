import 'dart:async';
import 'package:bolt/shared/widgets/app_notification.dart';
import 'package:bolt/shared/widgets/osm_map_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ActiveRunPage extends StatefulWidget {
  const ActiveRunPage({super.key});

  @override
  State<ActiveRunPage> createState() => _ActiveRunPageState();
}

class _ActiveRunPageState extends State<ActiveRunPage> {
  Timer? _holdToStopTimer;
  StreamSubscription<Position>? _positionSubscription;
  bool _isHoldingStop = false;
  int _secondsElapsed = 0;
  bool _isPaused = false;
  bool _isMinimized = false;
  OverlayEntry? _overlayEntry;

  double _distance = 0.0;
  double _pace = 0.0;
  final List<LatLng> _routePoints = [];
  LatLng? _currentCenter;
  late Timer _elapsedTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showNotification());
    _startLocationTracking();
    _startElapsedTimer();
  }

  void _startElapsedTimer() {
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused) {
        setState(() {
          _secondsElapsed++;
          _updatePace();
        });
      }
    });
  }

  void _updatePace() {
    if (_secondsElapsed == 0 || _distance == 0) {
      _pace = 0.0;
      return;
    }
    final hoursElapsed = _secondsElapsed / 3600.0;
    _pace = _distance / hoursElapsed;
  }

  Future<void> _startLocationTracking() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen(_onPositionUpdate);
  }

  void _onPositionUpdate(Position position) {
    if (_isPaused) return;

    final nextPoint = LatLng(position.latitude, position.longitude);
    if (_routePoints.isNotEmpty) {
      final lastPoint = _routePoints.last;
      final deltaMeters = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        nextPoint.latitude,
        nextPoint.longitude,
      );
      if (deltaMeters < 5) {
        return;
      }
      setState(() {
        _distance += deltaMeters / 1000;
        _routePoints.add(nextPoint);
        _currentCenter = nextPoint;
        _updatePace();
      });
    } else {
      setState(() {
        _routePoints.add(nextPoint);
        _currentCenter = nextPoint;
      });
    }
  }

  void _showNotification() {
    _overlayEntry = OverlayEntry(
      builder: (context) => const AppNotification(
        icon: Icons.flash_on,
        title: "Let's go!!!",
        subtitle: 'Slower and consistently',
      ),
    );

    Overlay.of(context).insert(_overlayEntry!)
;
    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _stopRun() {
    _overlayEntry?.remove();
    // TODO: Navigate to a run summary page or back to home
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _startHoldToStop() {
    _isHoldingStop = true;
    _holdToStopTimer?.cancel();
    _holdToStopTimer = Timer(const Duration(seconds: 3), () {
      if (_isHoldingStop) {
        _stopRun();
      }
    });
  }

  void _cancelHoldToStop() {
    _isHoldingStop = false;
    _holdToStopTimer?.cancel();
  }

  @override
  void dispose() {
    _holdToStopTimer?.cancel();
    _elapsedTimer.cancel();
    _positionSubscription?.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  String _formatTime() {
    return (_secondsElapsed ~/ 60).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OsmMapView(
            enableLocationTracking: false,
            centerOverride: _currentCenter,
            polylinePoints: _routePoints,
          ),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -4))
          ],
        ),
        child: _isMinimized ? _buildMinimizedStrip() : _buildExpandedSheet(),
      ),
    );
  }

  Widget _buildMinimizedStrip() {
    return GestureDetector(
      onTap: () => setState(() => _isMinimized = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.drag_handle, color: Colors.black38, size: 20),
            const SizedBox(width: 12),
            Text(
              '${_distance.toStringAsFixed(2)} km',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0088FF)),
            ),
            const Spacer(),
            Text(
              '${_formatTime()} mins',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0088FF)),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.expand_less, color: Color(0xFF0088FF), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedSheet() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.expand_more, color: Colors.black54),
              onPressed: () => setState(() => _isMinimized = true),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(height: 8),
          _buildStats(),
          const SizedBox(height: 20),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStatColumn('Distance', _distance.toStringAsFixed(2), 'km'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatColumn('Pace', _pace.toStringAsFixed(1), 'km/h'),
            _buildStatColumn('Time', _formatTime(), 'mins'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0088FF))),
            if (unit.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(unit,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    Widget stopButton = _buildControlButton(
      onTap: () {}, // tap does nothing
      onHoldStart: _startHoldToStop,
      onHoldEnd: _cancelHoldToStop,
      isPrimary: !_isPaused,
      icon: Icons.stop,
    );

    Widget pausePlayButton = _buildControlButton(
      onTap: _togglePause,
      isPrimary: _isPaused,
      icon: _isPaused ? Icons.play_arrow : Icons.pause,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _isPaused ? [pausePlayButton, stopButton] : [stopButton, pausePlayButton],
    );
  }

  Widget _buildControlButton({
    required VoidCallback onTap,
    VoidCallback? onHoldStart,
    VoidCallback? onHoldEnd,
    required bool isPrimary,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: (_) => onHoldStart?.call(),
      onLongPressEnd: (_) => onHoldEnd?.call(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary ? const Color(0xFF0088FF) : Colors.transparent,
          border: isPrimary ? null : Border.all(color: const Color(0xFF0088FF), width: 2),
        ),
        child: Icon(icon, color: isPrimary ? Colors.white : const Color(0xFF0088FF), size: 32),
      ),
    );
  }
}
