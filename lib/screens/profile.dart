import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'account_verification.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchUserData();
  }

  void _fetchUserData() async {
    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _userData!['profileImageUrl'] = image.path;
      });
      _firestore
          .collection('users')
          .doc(_user!.uid)
          .update({'profileImageUrl': image.path});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _userData!['profileImageUrl'] != null
                      ? NetworkImage(_userData!['profileImageUrl'])
                      : null,
                  child: _userData!['profileImageUrl'] == null
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              _userData!['fullName'] ?? 'User Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text(_userData!['userType'] == 'Donator'
                  ? 'Donator account verification'
                  : 'Recipient account verification'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountVerificationPage(
                            email: _userData!['email'],
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Privacy and security'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Location preferences'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Donee history'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}