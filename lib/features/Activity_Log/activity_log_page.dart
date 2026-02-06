import 'package:bolt/shared/widgets/see_more_button.dart';
import 'package:bolt/shared/widgets/weekly_stats_card.dart';
import 'package:flutter/material.dart';

class ActivityLogPage extends StatefulWidget {
  const ActivityLogPage({super.key});

  @override
  State<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  DateTimeRange? _selectedDateRange;
  String _sortBy = 'date'; // 'date', 'distance', 'time'
  int _itemsToShow = 3; // Start with 3 items
  bool _isLoading = false;

  // Sample data with more entries
  final List<Map<String, dynamic>> _allRuns = [
    {'date': DateTime(2026, 2, 5), 'distance': 6.8, 'time': 85},
    {'date': DateTime(2026, 2, 4), 'distance': 5.5, 'time': 68},
    {'date': DateTime(2026, 2, 3), 'distance': 9.2, 'time': 110},
    {'date': DateTime(2026, 2, 2), 'distance': 4.3, 'time': 48},
    {'date': DateTime(2026, 2, 1), 'distance': 7.6, 'time': 92},
    {'date': DateTime(2026, 1, 31), 'distance': 6.1, 'time': 75},
    {'date': DateTime(2026, 1, 30), 'distance': 8.9, 'time': 108},
    {'date': DateTime(2026, 1, 29), 'distance': 5.3, 'time': 64},
    {'date': DateTime(2026, 1, 28), 'distance': 7.2, 'time': 87},
    {'date': DateTime(2026, 1, 27), 'distance': 6.4, 'time': 78},
    {'date': DateTime(2026, 1, 26), 'distance': 4.8, 'time': 55},
    {'date': DateTime(2026, 1, 25), 'distance': 8.1, 'time': 98},
    {'date': DateTime(2026, 1, 24), 'distance': 5.7, 'time': 70},
    {'date': DateTime(2026, 1, 23), 'distance': 7.9, 'time': 96},
    {'date': DateTime(2026, 1, 22), 'distance': 6.2, 'time': 76},
    {'date': DateTime(2026, 1, 21), 'distance': 9.5, 'time': 115},
    {'date': DateTime(2026, 1, 20), 'distance': 6.0, 'time': 83},
    {'date': DateTime(2026, 1, 19), 'distance': 5.2, 'time': 65},
    {'date': DateTime(2026, 1, 18), 'distance': 8.5, 'time': 102},
    {'date': DateTime(2026, 1, 17), 'distance': 4.1, 'time': 45},
    {'date': DateTime(2026, 1, 16), 'distance': 7.3, 'time': 88},
    {'date': DateTime(2026, 1, 15), 'distance': 5.9, 'time': 72},
  ];

  List<Map<String, dynamic>> get _filteredAndSortedRuns {
    List<Map<String, dynamic>> filtered = _allRuns;

    // Filter by date range
    if (_selectedDateRange != null) {
      filtered = filtered.where((run) {
        return run['date'].isAfter(_selectedDateRange!.start) &&
            run['date'].isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'distance':
        filtered.sort((a, b) => b['distance'].compareTo(a['distance']));
        break;
      case 'time':
        filtered.sort((a, b) => b['time'].compareTo(a['time']));
        break;
      default:
        filtered.sort((a, b) => b['date'].compareTo(a['date']));
    }

    return filtered;
  }

  List<Map<String, dynamic>> get _displayedRuns {
    return _filteredAndSortedRuns.take(_itemsToShow).toList();
  }

  bool get _hasMoreData {
    return _itemsToShow < _filteredAndSortedRuns.length;
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _itemsToShow = 3; // Reset pagination when filtering
      });
    }
  }

  void _loadMore() async {
    setState(() => _isLoading = true);
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _itemsToShow += 3; // Load 3 more items
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Activity Log'),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFiltersBar(),
                const SizedBox(height: 20),
                const WeeklyStatsCard(),
                const SizedBox(height: 24),
                Text(
                  'History (${_filteredAndSortedRuns.length})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildHistoryList(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 40, right: 40),
              child: SeeMoreButton(
                onPressed: _hasMoreData ? _loadMore : null,
                isLoading: _isLoading,
                hasMoreData: _hasMoreData,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _pickDateRange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF0088FF), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedDateRange == null
                          ? 'Select Date Range'
                          : '${_selectedDateRange!.start.day} ${_monthName(_selectedDateRange!.start.month)} - ${_selectedDateRange!.end.day} ${_monthName(_selectedDateRange!.end.month)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedDateRange == null ? Colors.grey[600] : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_selectedDateRange != null)
                    GestureDetector(
                      onTap: () => setState(() {
                        _selectedDateRange = null;
                        _itemsToShow = 3;
                      }),
                      child: const Icon(Icons.close, size: 16, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.white,
          ),
          child: PopupMenuButton<String>(
            onSelected: (value) => setState(() {
              _sortBy = value;
              _itemsToShow = 3; // Reset pagination when sorting
            }),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'date',
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 12),
                    const Text('Sort by Date'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'distance',
                child: Row(
                  children: [
                    Icon(Icons.straighten, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 12),
                    const Text('Sort by Distance'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'time',
                child: Row(
                  children: [
                    Icon(Icons.hourglass_bottom, size: 18, color: Colors.grey[700]),
                    const SizedBox(width: 12),
                    const Text('Sort by Time'),
                  ],
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Icon(
                Icons.tune,
                color: Colors.grey[700],
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    final runs = _displayedRuns;

    if (_filteredAndSortedRuns.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'No runs found',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: runs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final run = runs[index];
        return _buildHistoryItem(
          date: '${run['date'].day} ${_monthName(run['date'].month)}',
          distance: '${run['distance']}km',
          time: '${(run['time'] ~/ 60)}h ${run['time'] % 60}min',
        );
      },
    );
  }

  Widget _buildHistoryItem(
      {required String date, required String distance, required String time}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.directions_run, color: Color(0xFF0088FF), size: 28),
            const SizedBox(width: 16),
            Text(
              date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    distance,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
