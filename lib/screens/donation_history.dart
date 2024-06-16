import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonationHistoryPage extends StatelessWidget {
  final User user;

  DonationHistoryPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('itemListings')
            .where('user', isEqualTo: user.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<DocumentSnapshot> donations = snapshot.data!.docs;

          if (donations.isEmpty) {
            return const Center(child: Text('No donations found.'));
          }

          return ListView.builder(
            itemCount: donations.length,
            itemBuilder: (context, index) {
              var donation = donations[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: donation['imageUrl'] != null
                      ? Image.network(donation['imageUrl'])
                      : Icon(Icons.image_not_supported),
                  title: Text(donation['title']),
                  subtitle: Text(donation['description']),
                  trailing: Text('Rating: ${donation['rating']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
