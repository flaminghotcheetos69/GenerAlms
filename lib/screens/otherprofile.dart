import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'listing_details.dart'; // Assuming listing_details.dart contains the ListingDetailsPage
import 'chat_conversation.dart'; // Import the file where ChatConversationPage is defined

class OtherProfilePage extends StatelessWidget {
  final String userId;

  const OtherProfilePage({Key? key, required this.userId}) : super(key: key);

  Future<Map<String, dynamic>> getUserInfo() async {
    var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getUserListings() async {
    var listingsSnapshot = await FirebaseFirestore.instance.collection('itemListings').where('userId', isEqualTo: userId).get();
    return listingsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<String> _getChatId() async {
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
      appBar: AppBar(
        title: Text('User Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserInfo(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          var user = userSnapshot.data ?? {};
          final String userImage = user['profileImageUrl'] ?? 'https://via.placeholder.com/50';
          final String userName = user['fullName'] ?? 'Unknown';
          final double rating = (user['rating'] is int) ? (user['rating'] as int).toDouble() : (user['rating'] as double? ?? 0.0);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                  radius: 50,
                ),
                SizedBox(height: 8),
                Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.red, size: 16),
                    Text(rating.toString()),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String chatId = await _getChatId();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatConversationPage(chatId: chatId, chatUserId: userId),
                      ),
                    );
                  },
                  child: Text('Message User'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Color(0xFFD33333),
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'User Listings',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: getUserListings(),
                  builder: (context, listingsSnapshot) {
                    if (listingsSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (listingsSnapshot.hasError) {
                      return Center(child: Text('Error: ${listingsSnapshot.error}'));
                    }

                    var listings = listingsSnapshot.data ?? [];
                    if (listings.isEmpty) {
                      return Center(child: Text('No listings available'));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listings.length,
                      itemBuilder: (context, index) {
                        var listing = listings[index];
                        final String imageUrl = listing['imageUrl'] ?? 'https://via.placeholder.com/150';
                        final String title = listing['title'] ?? 'No title';

                        return ListTile(
                          leading: Image.network(imageUrl),
                          title: Text(title),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListingDetailsPage(item: listing),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
