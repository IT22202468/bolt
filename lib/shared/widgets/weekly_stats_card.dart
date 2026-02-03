import 'dart:async';
import 'package:flutter/material.dart';

/// Card displaying weekly running statistics
/// Shows distance, rank, runs, time, and streak
class WeeklyStatsCard extends StatefulWidget {
  const WeeklyStatsCard({super.key});

  @override
  State<WeeklyStatsCard> createState() => _WeeklyStatsCardState();
}

class _WeeklyStatsCardState extends State<WeeklyStatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _distanceAnimation;
  late Animation<int> _rankAnimation;
  late Animation<int> _runsAnimation;
  late Animation<int> _timeHoursAnimation;
  late Animation<int> _timeMinutesAnimation;
  late Animation<int> _streakAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _distanceAnimation =
        Tween<double>(begin: 0, end: 12.3).animate(curvedAnimation);
    _rankAnimation = IntTween(begin: 0, end: 5).animate(curvedAnimation);
    _runsAnimation = IntTween(begin: 0, end: 5).animate(curvedAnimation);
    _timeHoursAnimation = IntTween(begin: 0, end: 1).animate(curvedAnimation);
    _timeMinutesAnimation = IntTween(begin: 0, end: 23).animate(curvedAnimation);
    _streakAnimation = IntTween(begin: 0, end: 6).animate(curvedAnimation);

    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This Week',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatItem(
                        label: 'Distance',
                        value: _distanceAnimation.value.toStringAsFixed(1),
                        unit: 'km',
                        isCompact: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatItem(
                        label: 'Rank',
                        value: _rankAnimation.value.toString(),
                        unit: '',
                        showTrendingUp: true,
                        isCompact: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: StatItem(
                        label: 'Runs',
                        value: _runsAnimation.value.toString(),
                        unit: '',
                        isCompact: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: StatItem(
                        label: 'Time',
                        value: _timeHoursAnimation.value.toString(),
                        unit: 'h',
                        secondaryValue:
                            _timeMinutesAnimation.value.toString(),
                        secondaryUnit: 'min',
                        isCompact: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: StatItem(
                        label: 'Streak',
                        value: _streakAnimation.value.toString(),
                        unit: '',
                        icon: Icons.bolt,
                        isCompact: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



/// Individual stat item component
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String? secondaryValue;
  final String? secondaryUnit;
  final bool showTrendingUp;
  final IconData? icon;
  final bool isCompact;

  const StatItem({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.secondaryValue,
    this.secondaryUnit,
    this.showTrendingUp = false,
    this.icon,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 370;

    double valueFontSize = isCompact
        ? (isSmallScreen ? 24 : 32)
        : (isSmallScreen ? 36 : 48);
    double unitFontSize = isSmallScreen ? 14 : 24;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isCompact) ...[
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
        ] else ...[
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
        ],
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: Colors.grey[700],
                  size: isCompact ? 24 : 32,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2196F3), // Blue color
                  height: 1.0,
                ),
              ),
              if (unit.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    unit,
                    style: TextStyle(
                      fontSize: unitFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              if (secondaryValue != null) ...[
                const SizedBox(width: 4),
                Text(
                  secondaryValue!,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                    height: 1.0,
                  ),
                ),
                if (secondaryUnit != null && secondaryUnit!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      secondaryUnit!,
                      style: TextStyle(
                        fontSize: unitFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
              ],
              if (showTrendingUp)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.trending_up,
                    color: Colors.grey[600],
                    size: 32,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
