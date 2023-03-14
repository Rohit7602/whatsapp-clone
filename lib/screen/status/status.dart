import 'package:flutter/material.dart';
import '../../helper/styles/app_style_sheet.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

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
                  'https://randomuser.me/api/portraits/women/$index.jpg'),
            ),
            title: Text(
              'User $index',
              style: GetTextTheme.sf14_regular
                  .copyWith(color: AppColors.whiteColor),
            ),
            subtitle: Text(
              'Yesterday, 10:15 AM',
              style: GetTextTheme.sf14_regular
                  .copyWith(color: AppColors.greyColor),
            ),
            trailing: const Icon(
              Icons.more_vert,
              color: AppColors.whiteColor,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.lightGreenColor,
        child: const Icon(Icons.camera_alt),
        onPressed: () {},
      ),
    );
  }
}
