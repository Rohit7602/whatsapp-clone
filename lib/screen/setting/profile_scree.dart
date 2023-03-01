import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48.0,
                backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/1.jpg'),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'John Doe',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8.0),
            Text(
              'This is my status',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.phone),
                SizedBox(width: 8.0),
                Text('+123 456 7890'),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8.0),
                Text('johndoe@example.com'),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8.0),
                Text('New York, USA'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
