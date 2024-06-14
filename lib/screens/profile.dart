import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String? _profileImageUrl;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadProfileImage();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      await _uploadProfileImage();
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage == null || _currentUser == null) return;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(_currentUser!.uid + '.jpg');
    await storageRef.putFile(_profileImage!);
    String downloadUrl = await storageRef.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).update({
      'profileImageUrl': downloadUrl,
    });
    setState(() {
      _profileImageUrl = downloadUrl;
    });
  }

  Future<void> _loadProfileImage() async {
    if (_currentUser == null) return;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
    setState(() {
      _profileImageUrl = userDoc['profileImageUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
                child: _profileImageUrl == null ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey) : null,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24.0),
            _buildProfileOption('Recipient account verification', Icons.verified_user),
            _buildProfileOption('Privacy and security', Icons.security),
            _buildProfileOption('Location preferences', Icons.location_on),
            _buildProfileOption('Donee history', Icons.history),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
      onTap: () {
        // Navigate to respective pages
      },
    );
  }
}
