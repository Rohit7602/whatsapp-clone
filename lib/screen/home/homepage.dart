// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/screen/chat/chat_room.dart';
import 'package:whatsapp_clone/database_event/event_listner.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/screen/setting/profile_screen.dart';
import 'package:whatsapp_clone/widget/custom_image.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';
import '../../styles/stylesheet.dart';
import '../../styles/textTheme.dart';
import '../contact/contact.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);

    DatabaseEventListner(context: context, provider: provider).getAllUsers();
    DatabaseEventListner(context: context, provider: provider)
        .fetchChatRoomsEventListner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 15),
        child: Consumer<GetterSetterModel>(
          builder: (context, data, chidl) {
            return data.targetUserModel.isEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 40),
                    alignment: Alignment.center,
                    height: 300,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(startChat),
                    )),
                  )
                : ListView.separated(
                    separatorBuilder: (context, i) => getHeight(15),
                    shrinkWrap: true,
                    itemCount: data.targetUserModel.length,
                    itemBuilder: (context, i) {
                      String dateTime = "";
                      if (data.targetUserModel[i].messageModel.sentOn
                          .toIso8601String()
                          .isNotEmpty) {
                        dateTime = DateFormat('hh:mm a').format(DateTime.parse(
                            data.targetUserModel[i].messageModel.sentOn
                                .toString()));
                      }

                      print(data.targetUserModel[i].userModel.profileImage);

                      return ListTile(
                        onTap: () {
                          pushTo(
                              context,
                              ChatRoomScreen(
                                  targetUser: data
                                      .targetUserModel[i].userModel.userId));
                        },
                        title: Text(
                          data.targetUserModel[i].userModel.number,
                        ),
                        subtitle: Row(
                          children: [
                            data.targetUserModel[i].messageModel.seen
                                ? const Icon(
                                    Icons.done_all,
                                    color: primaryColor,
                                    size: 15,
                                  )
                                : const Icon(
                                    Icons.check,
                                    color: primaryColor,
                                    size: 15,
                                  ),
                            const SizedBox(
                              width: 3,
                            ),
                            data.targetUserModel[i].messageModel.message.isEmpty
                                // ignore: prefer_const_constructors
                                ? Text("Start Chat")
                                : data.targetUserModel[i].messageModel
                                            .messageType ==
                                        'image'
                                    ? const Text("Photo")
                                    : data.targetUserModel[i].messageModel
                                                .messageType ==
                                            "text"
                                        ? Text(data.targetUserModel[i]
                                            .messageModel.message)
                                        : const Text("coming, soon"),
                          ],
                        ),
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: lightGreyColor),
                          child: data.targetUserModel[i].userModel.profileImage
                                  .isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    data.targetUserModel[i].userModel
                                        .profileImage,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 35,
                                  color: whiteColor,
                                ),
                        ),
                        trailing: Text(
                          dateTime.toString(),
                          style: TextThemeProvider.bodyTextSecondary
                              .copyWith(color: greyColor, fontSize: 12),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
      floatingActionButton: Consumer<GetterSetterModel>(
        builder: (context, data, child) {
          return data.targetUserModel.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      chatGIF,
                      height: 70,
                    ),
                    Image.asset(
                      arrowGIF,
                      height: 60,
                    ),
                    FloatingActionButton(
                      backgroundColor: primaryColor,
                      onPressed: () async {
                        pushTo(context, const ContactScreen());
                      },
                      child: const Icon(Icons.chat),
                    ),
                  ],
                )
              : FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () async {
                    pushTo(context, const ProfileScreen());
                  },
                  child: const Icon(Icons.chat),
                );
        },
      ),
    );
  }
}
