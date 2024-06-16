import 'package:flutter/material.dart';
import 'admin_verification.dart';
import 'admin_roles_perm.dart';
import 'admin_password_policies.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
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
            title: const Text('Account Verification'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VerificationScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('User Roles and Permissions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserRolesPermissions()),
              );
            },
          ),
          ListTile(
            title: const Text('Password Policies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordPolicies()),
              );
            },
          ),
        ],
      ),
    );
  }
}
