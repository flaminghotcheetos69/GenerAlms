import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pie Chart
            SizedBox(
              height: 200,
              child: charts.PieChart(
                _createSamplePieData(),
                animate: true,
                defaultRenderer: charts.ArcRendererConfig(
                  arcWidth: 60,
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.inside,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Bar Chart
            Expanded(
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          // Handle bottom navigation tap
        },
      ),
    );
  }

  // Sample data for Pie Chart
  List<charts.Series<ChartData, String>> _createSamplePieData() {
    final data = [
      ChartData('Item A', 25),
      ChartData('Item B', 50),
      ChartData('Item C', 25),
    ];

    return [
      charts.Series<ChartData, String>(
        id: 'Items',
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        data: data,
        labelAccessorFn: (ChartData row, _) => '${row.label}: ${row.value}',
      )
    ];
  }

  // Sample data for Bar Chart
  List<charts.Series<ChartData, String>> _createSampleBarData() {
    final data = [
      ChartData('Q1', 10),
      ChartData('Q2', 20),
      ChartData('Q3', 30),
      ChartData('Q4', 40),
    ];

    return [
      charts.Series<ChartData, String>(
        id: 'Donations',
        domainFn: (ChartData data, _) => data.label,
        measureFn: (ChartData data, _) => data.value,
        data: data,
      )
    ];
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}