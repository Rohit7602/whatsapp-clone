import 'package:flutter/material.dart';
import '../../helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';
import 'group_chat.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, i) {
            return ListTile(
              onTap: () => AppServices.pushTo(context, const GroupChatScreen()),
              title: const Text("Group Number 1"),
            );
          }),
    );
  }
}
