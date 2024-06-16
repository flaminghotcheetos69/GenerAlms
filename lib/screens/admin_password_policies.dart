import 'package:flutter/material.dart';
import 'admin_user_settings.dart'; 

class UserPasswordPolicies extends StatelessWidget {
  const UserPasswordPolicies({super.key});
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Policies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminToolsScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Password should be no less than 6 characters and any changes to password must be made from Firebase',
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}