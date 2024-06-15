import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'adminhplist.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            // Bar Chart Label
            const Text(
              'Users on Platform Over Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            // Bar Chart
            SizedBox(
              height: 300, // Decreased the height
              child: charts.BarChart(
                _createSampleBarData(),
                animate: true,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.transparent), // Invisible dummy item
            label: '',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
      ),
    );
  }

  // Sample data for Bar Chart
  List<charts.Series<ChartData, String>> _createSampleBarData() {
    final data = [
      ChartData('January', 50),
      ChartData('February', 100),
      ChartData('March', 150),
      ChartData('April', 200),
      ChartData('May', 250),
      ChartData('June', 300),
    ];

    return [
      charts.Series<ChartData, String>(
        id: 'Users on Platform',
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        data: data,
        labelAccessorFn: (ChartData row, _) => '${row.label}: ${row.value}',
      )
    ];
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}