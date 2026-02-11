import 'dart:async';
import 'package:bolt/shared/widgets/app_notification.dart';
import 'package:bolt/shared/widgets/osm_map_view.dart';
import 'package:flutter/material.dart';

class ActiveGoalRunPage extends StatefulWidget {
  final bool isDistanceGoal;
  const ActiveGoalRunPage({super.key, required this.isDistanceGoal});

  @override
  State<ActiveGoalRunPage> createState() => _ActiveGoalRunPageState();
}

class _ActiveGoalRunPageState extends State<ActiveGoalRunPage> {
  
  Timer? _holdToStopTimer;
  bool _isHoldingStop = false;
  final int _secondsElapsed = 12;
  bool _isPaused = false;
  OverlayEntry? _overlayEntry;

  // Static values until live tracking is wired in.
  final double _distance = 2.5;
  final double _pace = 9.8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showNotification());
  }

  void _showNotification() {
    _overlayEntry = OverlayEntry(
      builder: (context) => const AppNotification(
        icon: Icons.flash_on,
        title: "Let's go!!!",
        subtitle: 'Slower and consistently',
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
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
          const OsmMapView(),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 40),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStats(),
            const SizedBox(height: 20),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    final distanceStat = _buildStatColumn('Distance', _distance.toStringAsFixed(2), 'km');
    final timeStat = _buildStatColumn('Time', _formatTime(), 'mins');
    final paceStat = _buildStatColumn('Pace', _pace.toStringAsFixed(1), 'km/h');

    if (widget.isDistanceGoal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          distanceStat,
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [paceStat, timeStat],
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          timeStat,
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [paceStat, distanceStat],
          ),
        ],
      );
    }
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
