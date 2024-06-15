import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddDonationProductPage extends StatefulWidget {
  final User user;

  const AddDonationProductPage({Key? key, required this.user})
      : super(key: key);

  @override
  _AddDonationProductPageState createState() => _AddDonationProductPageState();
}

class _AddDonationProductPageState extends State<AddDonationProductPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef =
        storageRef.child('images/${DateTime.now().toIso8601String()}.jpg');
    await imagesRef.putFile(image);
    return await imagesRef.getDownloadURL();
  }

  Future<void> _addProduct() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please fill all fields and select an image')));
      return;
    }

    String imageUrl = await _uploadImage(_image!);

    await FirebaseFirestore.instance.collection('itemListings').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imageUrl': imageUrl,
      'user': widget.user.email,
      'userId': widget.user.uid,
      'userImage':
          'https://example.com/userImage.png', // Replace with actual user image if available
      'rating': 0.0,
      'approved': false,
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Product added successfully')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Donation Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            _image == null ? Text('No image selected.') : Image.file(_image!),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}