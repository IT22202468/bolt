import 'package:flutter/material.dart';
import 'package:bolt/shared/widgets/run_action_button.dart';
import 'package:bolt/shared/widgets/weekly_stats_card.dart';
import 'package:bolt/shared/widgets/weekly_goal_card.dart';
import 'package:bolt/shared/widgets/secondary_button.dart';

/// Home Dashboard Screen
/// Displays user's weekly running statistics and provides quick actions
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                const WeeklyStatsCard(),
                const SizedBox(height: 20),
                const WeeklyGoalCard(),
                const SizedBox(height: 24),
                _buildStartRunningSection(),
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'John',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey[300],
          child: const Icon(
            Icons.person,
            size: 32,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStartRunningSection() {
    return const Text(
      'Start Running',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildActionButtons() {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: RunActionButton(
                icon: Icons.directions_run,
                title: 'Free Run',
                subtitle: 'No goal Just go',
                titleStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600, // semibold
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: RunActionButton(
                icon: Icons.timer_outlined,
                title: 'Goal Run',
                subtitle: 'Set Distance of Time',
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        SecondaryButton(
          icon: Icons.auto_stories_outlined,
          label: 'View Activity log',
        ),
        SizedBox(height: 12),
        SecondaryButton(
          icon: Icons.leaderboard_outlined,
          label: 'Leaderboard',
        ),
      ],
    );
  }
}
