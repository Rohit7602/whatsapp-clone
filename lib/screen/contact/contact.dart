import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';
import '../../styles/textTheme.dart';
import '../chat/chat_room.dart';

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
              style: TextThemeProvider.heading2
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              "100 contacts",
              style: TextThemeProvider.bodyTextSecondary
                  .copyWith(fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeight(10),
            ListTile(
              leading: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: lightGreenColor),
                  child: const Icon(
                    Icons.group,
                    color: whiteColor,
                    size: 35,
                  )),
              title: Text(
                "New Group",
                style: TextThemeProvider.bodyTextSmall,
              ),
            ),
            getHeight(10),
            Text(
              "All Contacts",
              style: TextThemeProvider.bodyTextSmall.copyWith(color: greyColor),
            ),
            getHeight(10),
            userList.getAllUser.isEmpty
                ? const Text("You Don't have any contacts")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: userList.getAllUser.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          pushTo(
                              context,
                              ChatRoomScreen(
                                  targetUser:
                                      userList.getAllUser[index].userId));
                        },
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: lightGreyColor),
                          child: userList.getAllUser[index].profileImage == ""
                              ? const Icon(
                                  Icons.person,
                                  color: whiteColor,
                                  size: 40,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    userList.getAllUser[index].profileImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        title: Text(
                          userList.getAllUser[index].number,
                          style: TextThemeProvider.bodyTextSmall,
                        ),
                        subtitle: Text(
                          userList.getAllUser[index].description,
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
