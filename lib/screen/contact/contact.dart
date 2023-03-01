import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/chat/chat_room.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';

import '../../styles/textTheme.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final database = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var userList = Provider.of<GetterSetterModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact Screen",
              style: TextThemeProvider.bodyTextSmall,
            ),
            Text(
              "100 contacts",
              style: TextThemeProvider.bodyTextSecondary
                  .copyWith(fontWeight: FontWeight.w300),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox(10),
            Text(
              "All Contacts",
              style: TextThemeProvider.bodyTextSmall.copyWith(color: greyColor),
            ),
            sizedBox(10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: userList.getAllUser.length,
              itemBuilder: (context, index) {
                var userData = userList.getAllUser.firstWhere(
                    (element) => element["UserId"] == auth.currentUser!.uid);

                print(userList.getAllUser[index]["Number"]);

                return ListTile(
                  onTap: () => pushTo(
                      context,
                      ChatRoomScreen(
                          myData: userData,
                          targetUser: userList.getAllUser[index])),
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: lightGreyColor),
                    child: const Icon(
                      Icons.person,
                      color: whiteColor,
                      size: 40,
                    ),
                  ),
                  title: Text(
                    userList.getAllUser[index]["Number"],
                    style: TextThemeProvider.bodyTextSmall,
                  ),
                  subtitle: Text(
                    "Comming Soon..",
                    style: TextThemeProvider.bodyTextSecondary
                        .copyWith(color: greyColor, fontSize: 12),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
