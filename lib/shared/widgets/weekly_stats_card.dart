import 'package:flutter/material.dart';

/// Card displaying weekly running statistics
/// Shows distance, rank, runs, time, and streak
class WeeklyStatsCard extends StatelessWidget {
  const WeeklyStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: StatItem(
                    label: 'Distance',
                    value: '12.3',
                    unit: 'km',
                  ),
                ),
                Expanded(
                  child: StatItem(
                    label: 'Rank',
                    value: '5',
                    unit: '',
                    showTrendingUp: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: StatItem(
                    label: 'Runs',
                    value: '5',
                    unit: '',
                    isCompact: true,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: StatItem(
                    label: 'Time',
                    value: '1',
                    unit: 'h',
                    secondaryValue: '23',
                    secondaryUnit: 'min',
                    isCompact: true,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: StatItem(
                    label: 'Streak',
                    value: '6',
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
          const SizedBox(height: 8),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: Colors.grey[700],
                size: isCompact ? 24 : 32,
              ),
            ],
            Text(
              value,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2196F3), // Blue color
                height: 1.0,
              ),
            ),
            if (unit.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 4),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 24,
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
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2196F3),
                  height: 1.0,
                ),
              ),
              if (secondaryUnit != null && secondaryUnit!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 2, bottom: 4),
                  child: Text(
                    secondaryUnit!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
            ],
            if (showTrendingUp)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Icon(
                  Icons.trending_up,
                  color: Colors.grey[600],
                  size: 32,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
