import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';
import 'package:whatsapp_clone/styles/textTheme.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';

import 'call_screen.dart';

class RecentCallsScreen extends StatelessWidget {
  const RecentCallsScreen({super.key});

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
                  'https://randomuser.me/api/portraits/men/$index.jpg'),
            ),
            title: Text(
              'User $index',
              style:
                  TextThemeProvider.bodyTextSmall.copyWith(color: whiteColor),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yesterday, 10:15 AM',
                  style: TextThemeProvider.bodyTextSmall
                      .copyWith(color: greyColor),
                ),
                Text(
                  'Outgoing',
                  style: TextThemeProvider.bodyTextSmall
                      .copyWith(color: greyColor),
                ),
              ],
            ),
            trailing: const Icon(
              Icons.call,
              color: whiteColor,
            ),
            onTap: () => pushTo(context, CallScreen()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightGreenColor,
        child: const Icon(Icons.add_call),
        onPressed: () {},
      ),
    );
  }
}
