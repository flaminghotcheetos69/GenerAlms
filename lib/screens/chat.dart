import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_conversation.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Future<String> _getChatId(String userId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot chatSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: [currentUserId, userId])
        .get();

    if (chatSnapshot.docs.isNotEmpty) {
      return chatSnapshot.docs.first.id;
    } else {
      DocumentReference newChat = await FirebaseFirestore.instance.collection('chats').add({
        'users': [currentUserId, userId],
        'createdAt': Timestamp.now(),
      });
      return newChat.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatList(),
    );
  }
}

class ChatList extends StatelessWidget {
  Future<String> _getChatId(String userId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot chatSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: [currentUserId, userId])
        .get();

    if (chatSnapshot.docs.isNotEmpty) {
      return chatSnapshot.docs.first.id;
    } else {
      DocumentReference newChat = await FirebaseFirestore.instance.collection('chats').add({
        'users': [currentUserId, userId],
        'createdAt': Timestamp.now(),
      });
      return newChat.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').orderBy('fullName').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        var users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['profileImageUrl'] ?? ''),
                child: user['profileImageUrl'] == null ? Text(user['fullName'][0]) : null,
              ),
              title: Text(user['fullName']),
              onTap: () async {
                String chatId = await _getChatId(user.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatConversationPage(chatId: chatId, chatUserId: user.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
