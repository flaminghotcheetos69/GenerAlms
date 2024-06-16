import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatConversationPage extends StatefulWidget {
  final String chatUserId;

  ChatConversationPage({required this.chatUserId, required chatId});

  @override
  _ChatConversationPageState createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _checkUserVerification();
  }

  Future<void> _checkUserVerification() async {
    var currentUser = _auth.currentUser!;
    var userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
    if (userDoc.exists && userDoc['verified'] == true) {
      setState(() {
        _isVerified = true;
      });
    } else {
      _showVerificationAlert();
    }
  }

  void _showVerificationAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,  // This makes sure the dialog cannot be dismissed by tapping outside
      builder: (context) {
        return WillPopScope(  // Prevent the back button from closing the dialog
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Account Not Verified'),
            content: Text('Please verify your account to access this feature.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty || !_isVerified) return;

    var message = _messageController.text.trim();
    var currentUser = _auth.currentUser!;
    var chatDocId = _getChatDocId(currentUser.uid, widget.chatUserId);

    await _firestore.collection('chats').doc(chatDocId).collection('messages').add({
      'senderId': currentUser.uid,
      'receiverId': widget.chatUserId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chats').doc(chatDocId).set({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'chatUserId': widget.chatUserId,
    }, SetOptions(merge: true));

    _messageController.clear();
  }

  String _getChatDocId(String uid1, String uid2) {
    return uid1.compareTo(uid2) < 0 ? uid1 + '_' + uid2 : uid2 + '_' + uid1;
  }

  void _pickImage() async {
    // Pick an image to send
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = _auth.currentUser!;
    var chatDocId = _getChatDocId(currentUser.uid, widget.chatUserId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUserId), // Replace with the user's name
        backgroundColor: const Color(0xFFD33333),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(chatDocId)),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(String chatDocId) {
    return StreamBuilder(
      stream: _firestore.collection('chats').doc(chatDocId).collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var messages = snapshot.data!.docs;
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var message = messages[index];
            var isSentByCurrentUser = message['senderId'] == _auth.currentUser!.uid;

            return ListTile(
              title: Align(
                alignment: isSentByCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSentByCurrentUser ? const Color(0xFFEF4136) : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(message['message']),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: _pickImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
