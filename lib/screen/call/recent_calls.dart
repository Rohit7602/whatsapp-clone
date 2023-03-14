import 'package:flutter/material.dart';
import 'package:whatsapp_clone/helper/styles/app_style_sheet.dart';

import '../../helper/base_getters.dart';
import 'call_screen.dart';

class RecentCallsScreen extends StatelessWidget {
  const RecentCallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
              style: GetTextTheme.sf14_regular
                  .copyWith(color: AppColors.whiteColor),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yesterday, 10:15 AM',
                  style: GetTextTheme.sf14_regular
                      .copyWith(color: AppColors.greyColor),
                ),
                Text(
                  'Outgoing',
                  style: GetTextTheme.sf14_regular
                      .copyWith(color: AppColors.greyColor),
                ),
              ],
            ),
            trailing: const Icon(
              Icons.call,
              color: AppColors.whiteColor,
            ),
            onTap: () => AppServices.pushTo(context, const CallScreen()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.lightGreenColor,
        child: const Icon(Icons.add_call),
        onPressed: () {},
      ),
    );
  }
}
