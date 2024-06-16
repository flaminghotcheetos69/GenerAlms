import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_conversation.dart';

class ListingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const ListingDetailsPage({Key? key, required this.item}) : super(key: key);

  Future<Map<String, dynamic>> getUserInfo(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  Future<String> _getChatId(String userId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot chatSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: [currentUserId, userId]).get();

    if (chatSnapshot.docs.isNotEmpty) {
      return chatSnapshot.docs.first.id;
    } else {
      DocumentReference newChat =
          await FirebaseFirestore.instance.collection('chats').add({
        'users': [currentUserId, userId],
        'createdAt': Timestamp.now(),
      });
      return newChat.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        item['imageUrl'] ?? 'https://via.placeholder.com/150';
    final String title = item['title'] ?? 'No title';
    final String description =
        item['description'] ?? 'No description available';
    final String userId = item['userId'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserInfo(userId),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          var user = userSnapshot.data ?? {};
          final String userImage =
              user['profileImageUrl'] ?? 'https://via.placeholder.com/50';
          final String userName = user['fullName'] ?? 'Unknown';
          final double rating = (user['rating'] is int)
              ? (user['rating'] as int).toDouble()
              : (user['rating'] as double? ?? 0.0);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFD33333), Color(0xFFF63B3B)],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(description),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(userImage),
                          radius: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          userName,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.red, size: 16),
                        Text(rating.toString()),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String chatId = await _getChatId(userId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatConversationPage(
                            chatId: chatId, chatUserId: userId),
                      ),
                    );
                  },
                  child: Text('Message User'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFD33333),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
