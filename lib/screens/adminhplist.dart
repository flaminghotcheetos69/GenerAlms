import 'package:flutter/material.dart';
import 'package:generalms/screens/admin_comms.dart';
import 'package:generalms/screens/admin_user_settings.dart';
import 'adminHP.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Homepage'),
        
      ),  
      body: ListView(
        padding:  EdgeInsets.all(16.0),
        children:  [
          ListTile(
            title: Text('Admin User Setting'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminToolsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Communication Hub'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminCommHubsScreen()),
              );
            },
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
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminDBScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}