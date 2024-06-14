import 'package:flutter/material.dart';

class ListingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const ListingDetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide default values for null fields
    final String imageUrl = item['imageUrl'] ?? 'https://via.placeholder.com/150';
    final String title = item['title'] ?? 'No title';
    final String description = item['description'] ?? 'No description available';
    final String userImage = item['userImage'] ?? 'https://via.placeholder.com/50';
    final String user = item['user'] ?? 'Unknown';
    
    // Convert rating to double, handling both int and double types
    final double rating = (item['rating'] is int) ? (item['rating'] as int).toDouble() : (item['rating'] as double? ?? 0.0);

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
      body: Padding(
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
                      user,
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
          ],
        ),
      ),
    );
  }
}
