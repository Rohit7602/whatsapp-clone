// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:whatsapp_clone/model/message_model.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';

import '../../styles/textTheme.dart';
import '../home/homepage.dart';

class ChatRoom extends StatefulWidget {
  dynamic myData;
  dynamic targetUser;
  ChatRoom({super.key, required this.myData, required this.targetUser});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController messageController = TextEditingController();
  final database = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;
  ScrollController? scrollController;
  List<MessageModel> messageList = [];
  bool isFieldEmpty = false;

  String createChatRoomId(String user1, String user2) {
    if ((user1 == user2) == true) {
      if (user1[0].toLowerCase().codeUnits[0] >
          user2.toLowerCase().codeUnits[0]) {
        return "${"${user1}1"}_vs_$user2";
      } else {
        return "${user2}_vs_${"${user1}1"}";
      }
    } else {
      if (user1[0].toLowerCase().codeUnits[0] >
          user2.toLowerCase().codeUnits[0]) {
        return "${user1}_vs_$user2";
      } else {
        return "${user2}_vs_$user1";
      }
    }
  }

  @override
  void initState() {
    messageList.clear();

    scrollController = ScrollController();

    database
        .ref(
            "ChatRooms/${createChatRoomId(auth.currentUser!.uid, widget.targetUser["UserId"])}")
        .onValue
        .listen((event) {
      var msg = event.snapshot.children
          .map((e) => MessageModel.fromJson(
              e.value as Map<Object?, Object?>, e.key.toString()))
          .toList();
      if (!mounted) return;
      setState(() {
        messageList = msg;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(widget.targetUser["Name"]),
          actions: [
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "asset/whatsapp_bg/whatsapp_bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      var dateTime = DateFormat('hh:mm a').format(
                          DateTime.parse(messageList[index].sentOn.toString()));

                      if (messageList.isNotEmpty) {
                        scrollController!.animateTo(
                            scrollController!.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 10),
                            curve: Curves.bounceIn);
                      }

                      return Row(
                        mainAxisAlignment:
                            messageList[index].senderId == auth.currentUser!.uid
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: messageList[index].senderId ==
                                      auth.currentUser!.uid
                                  ? chatTileColor
                                  : primaryColor,
                              borderRadius: BorderRadius.circular(12).copyWith(
                                bottomRight: messageList[index].senderId ==
                                        auth.currentUser!.uid
                                    ? const Radius.circular(12)
                                    : const Radius.circular(0),
                                bottomLeft: messageList[index].senderId ==
                                        auth.currentUser!.uid
                                    ? const Radius.circular(0)
                                    : const Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 50),
                                  child: Text(
                                    messageList[index].message,
                                    style: TextThemeProvider.bodyTextSecondary
                                        .copyWith(
                                            color: whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
                                sizedBox(4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      dateTime,
                                      style: TextThemeProvider.helperText
                                          .copyWith(
                                              fontSize: 8,
                                              color: greyColor.shade300),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    messageList[index].senderId !=
                                            auth.currentUser!.uid
                                        ? messageList[index].seen
                                            ? const Icon(
                                                Icons.done_all,
                                                color: whiteColor,
                                                size: 15,
                                              )
                                            : const Icon(
                                                Icons.check,
                                                color: whiteColor,
                                                size: 15,
                                              )
                                        : const SizedBox(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 5, 15, 5),
                        margin: const EdgeInsets.only(
                          left: 10,
                          bottom: 10,
                        ),
                        height: 45,
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: TextFormField(
                          onChanged: (v) {
                            if (v.isEmpty) {
                              setState(() {
                                isFieldEmpty = true;
                              });
                            } else {
                              setState(() {
                                isFieldEmpty = false;
                              });
                            }
                          },
                          style: TextThemeProvider.bodyTextSmall
                              .copyWith(color: whiteColor),
                          controller: messageController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: isFieldEmpty
                                  ? const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.attach_file_outlined,
                                          color: lightGreyColor,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Icon(
                                            Icons.currency_rupee_sharp,
                                            color: lightGreyColor,
                                          ),
                                        ),
                                        Icon(
                                          Icons.camera_alt,
                                          color: lightGreyColor,
                                        ),
                                      ],
                                    )
                                  : const Icon(
                                      Icons.attach_file_outlined,
                                      color: lightGreyColor,
                                    ),
                              prefixIcon: const Icon(
                                Icons.emoji_emotions,
                                color: lightGreyColor,
                              ),
                              contentPadding: EdgeInsets.zero,
                              hintText: "Message.. ",
                              hintStyle: TextThemeProvider.bodyTextSmall
                                  .copyWith(color: lightGreyColor)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (messageController.text.isNotEmpty) {
                          sendMessaage();
                        } else {
                          null;
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: lightGreenColor),
                        child: isFieldEmpty
                            ? const Icon(
                                Icons.keyboard_voice_rounded,
                                color: whiteColor,
                                size: 25,
                              )
                            : const Icon(
                                Icons.send,
                                color: whiteColor,
                                size: 25,
                              ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }

  sendMessaage() async {
    Map<String, dynamic> bodyData = {
      "message": messageController.text,
      "senderId": widget.targetUser["UserId"],
      "seen": false,
      "sentOn": DateTime.now().toIso8601String(),
    };
    setState(() {
      lastMessage = messageController.text;
    });
    messageController.clear();

    await database
        .ref(
            "ChatRooms/${createChatRoomId(auth.currentUser!.uid, widget.targetUser["UserId"])}")
        .push()
        .set(bodyData);
  }
}
