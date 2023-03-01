import 'package:flutter/material.dart';
import '../../styles/stylesheet.dart';
import '../../widget/custom_widget.dart';
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
      backgroundColor: backgroundColor,
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, i) {
            return ListTile(
              onTap: () => pushTo(context, GroupChatScreen()),
              title: const Text("Group Number 1"),
            );
          }),
    );
  }
}
