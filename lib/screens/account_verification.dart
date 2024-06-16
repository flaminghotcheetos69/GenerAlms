import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountVerificationPage extends StatefulWidget {
  final String email;

  AccountVerificationPage({required this.email});

  @override
  _AccountVerificationPageState createState() =>
      _AccountVerificationPageState();
}

class _AccountVerificationPageState extends State<AccountVerificationPage> {
  File? _image;
  bool _hasUploadedImage = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _userId = querySnapshot.docs.first.id;
        });
        _checkIfImageUploaded(querySnapshot.docs.first.id);
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    }
  }

  Future<void> _checkIfImageUploaded(String userId) async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists && userDoc.data()?['verificationImageUrl'] != null) {
        setState(() {
          _hasUploadedImage = true;
        });
      }
    } catch (e) {
      print('Error checking if image uploaded: $e');
    }
  }

  Future<void> _pickImage() async {
    if (_hasUploadedImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have already uploaded an image.')),
      );
      return;
    }

    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image != null && _userId != null) {
      final storageRef = FirebaseStorage.instance.ref().child(
          'verificationApplications/${_userId}/${DateTime.now().toIso8601String()}.jpg');
      await storageRef.putFile(_image!);
      String imageUrl = await storageRef.getDownloadURL();
      return imageUrl;
    }
    return null;
  }

  Future<void> _storeImageUrlInFirestore(String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(_userId).update({
        'verificationImageUrl': imageUrl,
        'verificationTimestamp': FieldValue.serverTimestamp(),
      });
      print('Image URL stored in Firestore.');
      setState(() {
        _hasUploadedImage = true;
      });
    } catch (e) {
      print('Error storing image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Verification'),
        backgroundColor: Colors.red, // Change the background color as desired
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _image == null
                ? _hasUploadedImage
                    ? Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 100,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'You have already uploaded your ID image.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.green),
                          ),
                        ],
                      )
                    : Text(
                        'No image selected.',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      )
                : Image.file(_image!),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _hasUploadedImage
                    ? Colors.grey
                    : Colors.red, // Button color
                foregroundColor: Colors.white, // Text color
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _hasUploadedImage
                  ? null
                  : () async {
                      String? imageUrl = await _uploadImage();
                      if (imageUrl != null) {
                        await _storeImageUrlInFirestore(imageUrl);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('ID image uploaded successfully'),
                            backgroundColor:
                                Colors.green, // SnackBar background color
                          ),
                        );
                      }
                    },
              child: Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _hasUploadedImage
                    ? Colors.grey
                    : Colors.red, // Button color
                foregroundColor: Colors.white, // Text color
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
