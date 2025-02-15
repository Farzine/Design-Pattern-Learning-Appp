import 'package:dpla/models/user_progress.dart';
import 'package:dpla/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/providers/user_progress_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProgressState = ref.watch(userProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                ),
              )
            : const Text(
                'Deashboard',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        elevation: 0,
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification action
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ProfileScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userProgressState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : userProgressState.error != null
                ? Center(child: Text(userProgressState.error!))
                : userProgressState.progress.isEmpty
                    ? const Center(child: Text('No progress data available.'))
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Summary Cards
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildSummaryCard(
                                  context,
                                  title: 'Total Points',
                                  value: userProgressState.progress
                                      .fold(0, (sum, item) => sum + item.points)
                                      .toString(),
                                  color: Colors.purple[300]!,
                                ),
                                _buildSummaryCard(
                                  context,
                                  title: 'Progress',
                                  value:
                                      '${userProgressState.progress.fold(0, (sum, item) => sum + item.progress) ~/ userProgressState.progress.length}%',
                                  color: Colors.purple[300]!,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Progress Bar
                            const Text(
                              'Overall Progress',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: userProgressState.progress.fold(
                                      0, (sum, item) => sum + item.progress) /
                                  (100 * userProgressState.progress.length),
                              minHeight: 20,
                              backgroundColor: Colors.grey[300],
                              color: Colors.purple[400],
                            ),
                            const SizedBox(height: 30),

                            // Bar Chart for Practice Completed
                            const Text(
                              'Practice Sessions Completed',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 10,
                                  barTouchData: BarTouchData(enabled: true),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget:
                                            (double value, TitleMeta meta) {
                                          const style = TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          );
                                          String text = '';
                                          if (value.toInt() >= 0 &&
                                              value.toInt() <
                                                  userProgressState
                                                      .progress.length) {
                                            text = userProgressState
                                                .progress[value.toInt()]
                                                .designPattern;
                                          }
                                          return SideTitleWidget(
                                            axisSide: meta.axisSide,
                                            child: Text(text, style: style),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 2,
                                        getTitlesWidget:
                                            (double value, TitleMeta meta) {
                                          return Text(value.toInt().toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14));
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: List.generate(
                                      userProgressState.progress.length,
                                      (index) {
                                    final item =
                                        userProgressState.progress[index];
                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY:
                                              item.practiceCompleted.toDouble(),
                                          color: Colors.purple[400]!,
                                          width: 20,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Pie Chart for Learning and Test Completion
                            const Text(
                              'Learning & Test Completion',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: PieChart(
                                PieChartData(
                                  centerSpaceRadius: 40,
                                  sections: _getPieChartSections(
                                      userProgressState.progress),
                                  sectionsSpace: 4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Recent Progress Updates
                            const Text(
                              'Recent Progress Updates',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: userProgressState.progress.length,
                              itemBuilder: (context, index) {
                                final progress =
                                    userProgressState.progress[index];
                                return Card(
                                  elevation: 4.0,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: ListTile(
                                    leading: Icon(
                                      progress.learningCompleted
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: progress.learningCompleted
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    title: Text(progress.designPattern),
                                    subtitle: Text(
                                        'Last Updated: ${DateFormat.yMMMd().add_jm().format(progress.updatedAt)}'),
                                    trailing: Text('${progress.progress}%'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }

  /// Builds a summary card widget
  Widget _buildSummaryCard(BuildContext context,
      {required String title, required String value, required Color color}) {
    return Expanded(
      child: Card(
        color: color,
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Generates pie chart sections based on learning and test completion
  List<PieChartSectionData> _getPieChartSections(
      List<UserProgress> progressList) {
    int totalLearning = progressList.where((p) => p.learningCompleted).length;
    int totalTest = progressList.where((p) => p.testCompleted).length;

    return [
      PieChartSectionData(
        color: const Color.fromARGB(255, 191, 126, 240),
        value: totalLearning.toDouble(),
        title: 'Completed',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: totalTest.toDouble(),
        title: 'Tests\nCompleted',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 8, 84, 107),
        value: (progressList.length - totalLearning - totalTest).toDouble(),
        title: 'Pending',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ];
  }
}
