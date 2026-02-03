import 'package:bolt/features/Activity_Log/activity_log_page.dart';
import 'package:bolt/features/Free_Run/free_run_page.dart';
import 'package:bolt/features/Goal_Run/goal_run_page.dart';
import 'package:bolt/features/Leaderboard/leaderboard_page.dart';
import 'package:bolt/features/Profile/profile_page.dart';
import 'package:bolt/features/Stats/stats_page.dart';
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
                _buildHeader(context),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StatsPage()),
                  ),
                  child: const WeeklyStatsCard(),
                ),
                const SizedBox(height: 8),
                const WeeklyGoalCard(),
                const SizedBox(height: 8),
                _buildStartRunningSection(),
                const SizedBox(height: 8),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[300],
            child: const Icon(
              Icons.person,
              size: 32,
              color: Colors.grey,
            ),
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

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RunActionButton(
                  icon: Icons.directions_run,
                  title: 'Free Run',
                  subtitle: 'No goal Just go',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FreeRunPage(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RunActionButton(
                  icon: Icons.timer_outlined,
                  title: 'Goal Run',
                  subtitle: 'Set Distance of Time',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoalRunPage(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SecondaryButton(
          icon: Icons.auto_stories_outlined,
          label: 'View Activity log',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ActivityLogPage(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SecondaryButton(
          icon: Icons.leaderboard_outlined,
          label: 'Leaderboard',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LeaderboardPage(),
            ),
          ),
        ),
      ],
    );
  }
}
