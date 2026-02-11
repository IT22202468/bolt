import 'package:bolt/features/Auth/auth_page.dart';
import 'package:bolt/shared/widgets/logout_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// --- Data Models for Achievements ---

class Badge {
  final String name;
  final String description;
  final String tier;
  final Map<String, dynamic> requirement;

  const Badge({
    required this.name,
    required this.description,
    required this.tier,
    required this.requirement,
  });
}

class SecretBadge {
  final String name;
  final String unlockMessage;
  final Map<String, dynamic> condition;

  const SecretBadge(
      {required this.name, required this.unlockMessage, required this.condition});
}

class AchievementCategory {
  final String id;
  final String displayName;
  final IconData icon;
  final List<Badge> badges;

  const AchievementCategory({
    required this.id,
    required this.displayName,
    required this.icon,
    required this.badges,
  });
}

// --- Achievement Definitions ---

final List<AchievementCategory> achievementCategories = [
  const AchievementCategory(
      id: 'distance',
      displayName: 'Distance',
      icon: Icons.directions_run,
      badges: [
        Badge(
            tier: 'bronze',
            requirement: {'type': 'total_distance_km', 'value': 25},
            name: 'Trail_Starter',
            description:
                'Every journey begins with a single stride. You’ve officially started your running story.'),
        Badge(
            tier: 'silver',
            requirement: {'type': 'total_distance_km', 'value': 100},
            name: 'Road_Warrior',
            description: '100 km conquered. The road now knows your name.'),
        Badge(
            tier: 'gold',
            requirement: {'type': 'total_distance_km', 'value': 300},
            name: 'Distance_Dominator',
            description: 'You don’t just run distances, you dominate them.'),
        Badge(
            tier: 'platinum',
            requirement: {'type': 'total_distance_km', 'value': 750},
            name: 'Endurance_Titan',
            description:
                'Your endurance is legendary. Few runners reach this level.'),
      ]),
  const AchievementCategory(
      id: 'streak',
      displayName: 'Streak',
      icon: Icons.local_fire_department,
      badges: [
        Badge(
            tier: 'bronze',
            requirement: {'type': 'streak_days', 'value': 5},
            name: 'Spark_Igniter',
            description: 'Consistency sparks greatness. You’ve lit the flame.'),
        Badge(
            tier: 'silver',
            requirement: {'type': 'streak_days', 'value': 14},
            name: 'Momentum_Builder',
            description: 'Two weeks strong. Momentum is now on your side.'),
        Badge(
            tier: 'gold',
            requirement: {'type': 'streak_days', 'value': 30},
            name: 'Consistency_Machine',
            description: '30 days unstoppable. Discipline defines you.'),
        Badge(
            tier: 'platinum',
            requirement: {'type': 'streak_days', 'value': 60},
            name: 'Unbreakable_Force',
            description: 'Two months without quitting. You are built different.'),
      ]),
  const AchievementCategory(
      id: 'runs',
      displayName: 'Runs',
      icon: Icons.run_circle_outlined,
      badges: [
        Badge(
            tier: 'bronze',
            requirement: {'type': 'total_runs', 'value': 10},
            name: 'Stride_Initiate',
            description: '10 runs in. You’re no longer a beginner.'),
        Badge(
            tier: 'silver',
            requirement: {'type': 'total_runs', 'value': 50},
            name: 'Pace_Keeper',
            description: '50 sessions completed. You’ve found your rhythm.'),
        Badge(
            tier: 'gold',
            requirement: {'type': 'total_runs', 'value': 120},
            name: 'Rhythm_Master',
            description: '120 runs strong. Running is now part of who you are.'),
        Badge(
            tier: 'platinum',
            requirement: {'type': 'total_runs', 'value': 250},
            name: 'Relentless_Runner',
            description: '250 runs. Relentless effort. Elite mindset.'),
      ]),
  const AchievementCategory(
      id: 'active_months',
      displayName: 'Active Months',
      icon: Icons.calendar_today,
      badges: [
        Badge(
            tier: 'bronze',
            requirement: {'type': 'active_months', 'value': 1},
            name: 'Fresh_Footprints',
            description: 'One month committed. Your habit is forming.'),
        Badge(
            tier: 'silver',
            requirement: {'type': 'active_months', 'value': 3},
            name: 'Habit_Former',
            description: '90 days of dedication. This is a lifestyle now.'),
        Badge(
            tier: 'gold',
            requirement: {'type': 'active_months', 'value': 6},
            name: 'Dedicated_Athlete',
            description: 'Half a year strong. That’s real commitment.'),
        Badge(
            tier: 'platinum',
            requirement: {'type': 'active_months', 'value': 12},
            name: 'Loyal_Legend',
            description: 'A full year of running. You’ve earned legendary status.'),
      ]),
];

final List<SecretBadge> secretBadges = [
  const SecretBadge(
      name: 'Sunrise_Phantom',
      condition: {
        'type': 'early_runs_before_time',
        'runs_required': 5,
        'before_time': '06:00'
      },
      unlockMessage: 'While the world slept, you were already winning.'),
  const SecretBadge(
      name: 'Midnight_Strider',
      condition: {
        'type': 'late_runs_after_time',
        'runs_required': 3,
        'after_time': '23:30'
      },
      unlockMessage: 'Night belongs to the bold.'),
  const SecretBadge(
      name: 'Explorer_Mode',
      condition: {
        'type': 'different_locations',
        'distance_km': 5,
        'locations_required': 5
      },
      unlockMessage: 'The world is your track.'),
  const SecretBadge(
      name: 'Comeback_King',
      condition: {'type': 'return_after_inactivity_days', 'days': 30},
      unlockMessage: 'Champions always return.'),
  const SecretBadge(
      name: 'Personal_Best_Breaker',
      condition: {'type': 'beat_personal_best', 'distance_km': 5},
      unlockMessage: 'You outran your past self.'),
  const SecretBadge(
      name: 'Mind_Over_Miles',
      condition: {'type': 'longest_run_ever'},
      unlockMessage: 'Limits are meant to be rewritten.'),
  const SecretBadge(
      name: 'Precision_Runner',
      condition: {
        'type': 'exact_distance_finish',
        'allowed_distances_km': [5, 10],
        'tolerance_km': 0.01
      },
      unlockMessage: 'Perfect execution.'),
];

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettingsMenu(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 32),
          _buildAchievements(),
        ],
      ),
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: LogoutButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthPage()),
                (route) => false,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Runner';
    final photoUrl = user?.photoURL;
    final username = user?.email?.split('@').first ?? 'runner';

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: photoUrl == null
              ? const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          displayName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '@$username',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _badgeTierColor(String tier) {
    switch (tier) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'platinum':
        return const Color(0xFFE5E4E2);
      default:
        return Colors.amber;
    }
  }

  Widget _buildAchievements() {
    // Simulate user's achieved achievements
    const Set<String> achievedNames = {
      'Trail_Starter',
      'Road_Warrior',
      'Spark_Igniter',
      'Social_Sprinter',
      'Sunrise_Phantom',
    };
    final int totalAchievements =
        achievementCategories.fold(0, (sum, cat) => sum + cat.badges.length) +
            secretBadges.length;
    final int achievedCount = achievedNames.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements ($achievedCount/$totalAchievements)',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...achievementCategories.map((category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  category.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              ...category.badges.map((badge) {
                final bool isAchieved = achievedNames.contains(badge.name);
                final Color iconColor =
                    isAchieved ? _badgeTierColor(badge.tier) : Colors.grey[300]!;
                final Color textColor = isAchieved ? Colors.black : Colors.grey;

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[200]!),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(category.icon, color: iconColor, size: 40),
                    title: Text(
                      badge.name.replaceAll('_', ' '),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textColor),
                    ),
                    subtitle: Text(
                      badge.description,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                );
              }),
            ],
          );
        }),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Secret Badges',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ),
        ...secretBadges.map((badge) {
          final bool isAchieved = achievedNames.contains(badge.name);
          final Color iconColor = isAchieved ? Colors.deepPurple : Colors.grey[300]!;
          final Color textColor = isAchieved ? Colors.black : Colors.grey;

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.star, color: iconColor, size: 40),
              title: Text(
                isAchieved ? badge.name.replaceAll('_', ' ') : '????????',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              subtitle: Text(
                isAchieved ? badge.unlockMessage : 'Keep running to find out.',
                style: TextStyle(color: textColor),
              ),
            ),
          );
        }),
      ],
    );
  }
}
