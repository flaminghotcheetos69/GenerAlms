import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailNotificationScreen extends StatefulWidget {
  const EmailNotificationScreen({super.key});

  @override
  _EmailNotificationScreenState createState() => _EmailNotificationScreenState();
}

class _EmailNotificationScreenState extends State<EmailNotificationScreen> {
  final TextEditingController _emailContentController = TextEditingController();

  Future<void> _saveDraft() async {
    if (_emailContentController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('emailDrafts').add({
        'Content': _emailContentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved successfully')),
      );

      _emailContentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft content cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Notification Settings'),
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
            TextField(
              controller: _emailContentController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Draft Email',
                hintText: 'Enter your email content here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDraft,
              child: const Text('Save Draft'),
            ),
          ],
        ),
      ),
    );
  }
}