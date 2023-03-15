import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import '../../helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';
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
    var userList = Provider.of<GetterSetterModel>(context).getAllUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact Screen", style: GetTextTheme.sf18_medium),
            Text("100 contacts", style: GetTextTheme.sf12_medium),
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
            AppServices.addHeight(10),
            ListTile(
              leading: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.lightGreenColor),
                  child: const Icon(
                    Icons.group,
                    color: AppColors.whiteColor,
                    size: 35,
                  )),
              title: Text(
                "New Group",
                style: GetTextTheme.sf14_regular,
              ),
            ),
            AppServices.addHeight(10),
            Text(
              "All Contacts",
              style: GetTextTheme.sf14_regular
                  .copyWith(color: AppColors.greyColor),
            ),
            AppServices.addHeight(10),
            userList.isEmpty
                ? const Text("You Don't have any contacts")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          AppServices.pushTo(
                              context,
                              ChatRoomScreen(
                                  targetUser: userList[index].userId));
                        },
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.lightGreyColor),
                          child: userList[index].profileImage == ""
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.whiteColor,
                                  size: 40,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    userList[index].profileImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        title: Text(
                          userList[index].number,
                          style: GetTextTheme.sf14_regular,
                        ),
                        subtitle: Text(
                          userList[index].description,
                          style: GetTextTheme.sf12_medium
                              .copyWith(color: AppColors.greyColor),
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
