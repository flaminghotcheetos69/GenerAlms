import 'package:flutter/material.dart';
import 'package:generalms/screens/admin_user_settings.dart';
import 'adminHP.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Homepage'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),  
      body: ListView(
        padding:  EdgeInsets.all(16.0),
        children:  [
          ListTile(
            title: Text('Admin User Setting'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminSettingsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Communication Hub'),
          ),
          ListTile(
            title: Text('Security and Privacy Settings'),
          ),
          ListTile(
            title: Text('Report and Analysis Setting'),
          ),
          ListTile(
            title: Text('Backup and Recovery Settings'),
          ),
          ListTile(
            title: Text('Integration Setting'),
          ),
          ListTile(
            title: Text('Customization Setting'),
          ),
         ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.transparent),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Dashboard',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
         switch (index) {
            case 0:
              // Handle Profile button press
              break;
            case 1:
              // Navigate to Admin Dashboard Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
              );
              break;
          }
        },
      ),
    );
  }
}
