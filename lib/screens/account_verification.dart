import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class AccountVerificationPage extends StatefulWidget {
  final String userType;

  AccountVerificationPage({required this.userType});

  @override
  _AccountVerificationPageState createState() =>
      _AccountVerificationPageState();
}

class _AccountVerificationPageState extends State<AccountVerificationPage> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image != null) {
      final storageRef = FirebaseStorage.instance.ref().child(
          'verificationApplications/${widget.userType}/${DateTime.now().toIso8601String()}.jpg');
      await storageRef.putFile(_image!);
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl; // Return imageUrl from upload method
    }
    return null;
  }

  Future<void> _storeImageUrlInFirestore(String imageUrl) async {
    // Update Firestore with the imageUrl
    try {
      await FirebaseFirestore.instance
          .collection('verificationApplications')
          .doc(widget.userType)
          .set({'imageUrl': imageUrl}, SetOptions(merge: true));
      print('Image URL stored in Firestore.');
    } catch (e) {
      print('Error storing image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Verification (${widget.userType})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image == null ? Text('No image selected.') : Image.file(_image!),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () async {
                String? imageUrl = await _uploadImage();
                if (imageUrl != null) {
                  await _storeImageUrlInFirestore(imageUrl);
                }
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
