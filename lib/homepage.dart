import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listings'),
      ),
      body: Column(
        children: [
          Padding(
  padding: const EdgeInsets.all(8.0),
  child: TextField(
    decoration: InputDecoration(
      hintText: 'Search',
      hintStyle: TextStyle(color: Colors.red),
      prefixIcon: Icon(Icons.search, color: Colors.red),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide.none,
      ),
    ),
  ),
),

          Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('itemListings').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      List<DocumentSnapshot> items = snapshot.data!.docs;

      return SizedBox(
        height: 400, // Set a fixed height here
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index].data() as Map<String, dynamic>;
            return InkWell(
  onTap: () {
    print("tapped");
  },
  splashColor: Colors.grey.withOpacity(0.5), // Customize the splash color
  child: Card(
    elevation: 4, // Add a shadow
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
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
                colors: [Colors.blue, Colors.green], // Use gradient colors
              ),
            ),
            child: Image.network(
              item['imageUrl'],
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            item['title'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(item['userImage']),
          radius: 12,
        ),
        SizedBox(width: 8),
        Text(
          item['user'],
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
    Row(
      children: [
        Icon(Icons.star, color: Colors.red, size: 16),
        Text(item['rating'].toString()),
      ],
    ),
  ],
),

        ],
      ),
    ),
  ),
);






          },
        ),
      );
    },
  ),
),

        ],
      ),
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(1), // Increased opacity for a stronger shadow
        spreadRadius: 5,
        blurRadius: 10, // Increased blur radius for a stronger shadow
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    ),
    child: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Listings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      selectedItemColor: Theme.of(context).primaryColor,
      currentIndex: 0,
      onTap: (int index) {
        // Handle navigation to different pages
      },
    ),
  ),
),


    );
  }
}


