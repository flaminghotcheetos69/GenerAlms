import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:generalms/screens/admin_user_settings.dart';

class UserVerificationScreen extends StatefulWidget {
  @override
  UserVerificationScreenState createState() => UserVerificationScreenState();
}

class UserVerificationScreenState extends State<UserVerificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, bool> _verifiedStatus = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    QuerySnapshot userSnapshot = await _firestore.collection('users').get();
    setState(() {
      for (var doc in userSnapshot.docs) {
        _verifiedStatus[doc.id] = doc['verified'];
      }
    });
  }

  Future<Map<String, dynamic>> _getVerificationApplication(String userId) async {
    DocumentSnapshot verificationDoc = await _firestore.collection('verificationApplications').doc(userId).get();
    if (verificationDoc.exists) {
      return verificationDoc.data() as Map<String, dynamic>;
    }
    return {};
  }

  void _toggleVerified(String userId) {
    setState(() {
      _verifiedStatus[userId] = !_verifiedStatus[userId]!;
    });
  }

  Future<void> _saveChanges() async {
    WriteBatch batch = _firestore.batch();
    _verifiedStatus.forEach((userId, verified) {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      batch.update(userRef, {'verified': verified});
    });
    await batch.commit();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Changes saved successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Screen'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminToolsScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore.collection('users').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var userDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              var userDoc = userDocs[index];
              return FutureBuilder<Map<String, dynamic>>(
                future: _getVerificationApplication(userDoc.id),
                builder: (context, verificationSnapshot) {
                  if (!verificationSnapshot.hasData) {
                    return ListTile(title: Text('Loading...'));
                  }
                  var verificationData = verificationSnapshot.data!;
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(userDoc['profileImageUrl']),
                      ),
                      title: Text(userDoc['fullName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User Type: ${userDoc['userType']}'),
                          Text('Verified: ${_verifiedStatus[userDoc.id] ?? false}'),
                          verificationData.containsKey('imageURL')
                              ? CachedNetworkImage(
                                  imageUrl: verificationData['imageURL'],
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                )
                              : Container(),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          _verifiedStatus[userDoc.id]! ? Icons.check_box : Icons.check_box_outline_blank,
                        ),
                        onPressed: () => _toggleVerified(userDoc.id),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}