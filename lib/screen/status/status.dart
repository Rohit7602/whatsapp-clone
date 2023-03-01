import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/textTheme.dart';

import '../../styles/stylesheet.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/$index.jpg'),
            ),
            title: Text(
              'User $index',
              style:
                  TextThemeProvider.bodyTextSmall.copyWith(color: whiteColor),
            ),
            subtitle: Text(
              'Yesterday, 10:15 AM',
              style: TextThemeProvider.bodyTextSmall.copyWith(color: greyColor),
            ),
            trailing: const Icon(
              Icons.more_vert,
              color: whiteColor,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightGreenColor,
        child: const Icon(Icons.camera_alt),
        onPressed: () {},
      ),
    );
  }
}
