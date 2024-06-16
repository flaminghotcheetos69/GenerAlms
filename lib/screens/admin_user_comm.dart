import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEmailScreen extends StatefulWidget {
  const AdminEmailScreen({super.key});

  @override
  _AdminEmailScreenState createState() => _AdminEmailScreenState();
}

class _AdminEmailScreenState extends State<AdminEmailScreen> {
  final List<String> _selectedUsers = [];
  String? _selectedEmail;
  List<Map<String, dynamic>> _emailDrafts = [];

  @override
  void initState() {
    super.initState();
    _loadEmailDrafts();
  }

  Future<void> _loadEmailDrafts() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('emailDrafts').get();
    setState(() {
      _emailDrafts = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  Future<void> _sendEmail() async {
    if (_selectedUsers.isEmpty || _selectedEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both users and an email draft.')),
      );
      return;
    }

    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email sent to ${_selectedUsers.length} users.')),
    );

    
    setState(() {
      _selectedUsers.clear();
      _selectedEmail = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Communication Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;

                return ListView(
                  children: users.map((user) {
                    final userData = user.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(userData['email']),
                      trailing: Checkbox(
                        value: _selectedUsers.contains(user.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedUsers.add(user.id);
                            } else {
                              _selectedUsers.remove(user.id);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              hint: const Text('Select Email Draft'),
              value: _selectedEmail,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEmail = newValue;
                });
              },
              items: _emailDrafts.map((draft) {
                return DropdownMenuItem<String>(
                  value: draft['Content'],
                  child: Text(draft['Content']),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendEmail,
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }
}
