import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  void _searchUsers() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('fullName', isGreaterThanOrEqualTo: query)
        .where('fullName', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    setState(() {
      _searchResults.clear();
      for (var doc in usersSnapshot.docs) {
        _searchResults.add(doc.data() as Map<String, dynamic>);
      }
    });
  }

  void _startChat(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(chatUserId: userId)),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: const Color(0xFFD33333),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.add),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchUsers,
                  ),
                ),
              ),
            ),
          if (_isSearching && _searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  var user = _searchResults[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['profileImageUrl'] ?? ''),
                      child: user['profileImageUrl'] == null ? Text(user['fullName'][0]) : null,
                    ),
                    title: Text(user['fullName']),
                    onTap: () => _startChat(user['userId']),
                  );
                },
              ),
            ),
          Expanded(child: ChatList()),
        ],
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final List<String> chatUsers = ['User 1', 'User 2', 'User 3']; // Dummy data

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatUsers.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(chatUsers[index][0]),
          ),
          title: Text(chatUsers[index]),
          subtitle: Text('Last message preview...'),
          onTap: () {
            // Navigate to chat screen with selected user
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(chatUserId: chatUsers[index])),
            );
          },
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String chatUserId;

  ChatScreen({required this.chatUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    // Send the message
    _messageController.clear();
  }

  void _pickImage() async {
    // Pick an image to send
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUserId), // Replace with the user's name
        backgroundColor: const Color(0xFFD33333),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    // Placeholder for message list
    return ListView.builder(
      itemCount: 10, // Dummy data
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Message $index'),
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
