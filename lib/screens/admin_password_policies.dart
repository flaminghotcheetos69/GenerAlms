import 'package:flutter/material.dart';

class PasswordPolicies extends StatelessWidget {
  PasswordPolicies({super.key});
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Setting'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Verification Screen Content Goes Here'),
      ),
    );
  }
}