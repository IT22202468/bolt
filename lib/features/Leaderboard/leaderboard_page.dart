import 'package:bolt/shared/widgets/see_more_button.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  // Dummy data for the leaderboard
  final List<Map<String, dynamic>> leaderboardData = const [
    {'rank': 1, 'name': 'Tony', 'surname': 'Stark', 'points': 120, 'avatar': 'https://ssl.gstatic.com/s2/oz/images/sge/grey_silhouette.png'},
    {'rank': 2, 'name': 'Peter', 'surname': 'Parker', 'points': 100, 'avatar': 'https://ssl.gstatic.com/s2/oz/images/sge/grey_silhouette.png'},
    {'rank': 3, 'name': 'Steve', 'surname': 'Rogers', 'points': 90, 'avatar': 'https://ssl.gstatic.com/s2/oz/images/sge/grey_silhouette.png'},
    {'rank': 4, 'name': 'Natasha', 'surname': 'Romanoff', 'points': 80},
    {'rank': 5, 'name': 'Wanda', 'surname': 'Maximoff', 'points': 70},
    {'rank': 6, 'name': 'Bruce', 'surname': 'Banner', 'points': 60},
    {'rank': 7, 'name': 'T\'Challa', 'surname': '', 'points': 50},
    {'rank': 8, 'name': 'Carol', 'surname': 'Danvers', 'points': 40},
    {'rank': 10, 'name': 'Sam', 'surname': 'Wilson', 'points': 30},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 100.0),
            child: Column(
              children: [
                _buildTopThree(),
                const SizedBox(height: 24),
                _buildLeaderboardList(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
              child: SeeMoreButton(
                onPressed: () {
                  // TODO: Implement see more functionality
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    final topThree = leaderboardData.take(3).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTopRanker(topThree[1], Colors.grey[300]!, 40),
        _buildTopRanker(topThree[0], const Color(0xFFFFD700), 50),
        _buildTopRanker(topThree[2], const Color(0xFFE0A97E), 35),
      ],
    );
  }

  Widget _buildTopRanker(
      Map<String, dynamic> user, Color color, double avatarRadius) {
    return Column(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundImage: NetworkImage(user['avatar'] as String),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${user['rank']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                user['name'] as String,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user['surname'] as String,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                '${user['points']} pts',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildLeaderboardList() {
    final restOfLeaderboard = leaderboardData.skip(3).toList();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: restOfLeaderboard.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = restOfLeaderboard[index];
        return _buildLeaderboardItem(user);
      },
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> user) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Text(
              '#${user['rank']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0088FF),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user['surname'].isNotEmpty)
                  Text(
                    user['surname'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              '${user['points']} pts',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
