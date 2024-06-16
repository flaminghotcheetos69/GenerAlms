import 'package:flutter/material.dart';
import 'package:generalms/screens/admin_user_comm.dart';
import 'admin_email_nf.dart'; 

class AdminCommsScreen extends StatelessWidget {
  const AdminCommsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Communication Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Email Notification Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmailNotificationSettingsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('User Communication Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserCommunicationSettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

