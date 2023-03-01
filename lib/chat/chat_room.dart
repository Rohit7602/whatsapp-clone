// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/screen/home/homepage.dart';
import 'package:whatsapp_clone/model/message_model.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';
import '../styles/textTheme.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatRoomScreen extends StatefulWidget {
  dynamic myData;
  dynamic targetUser;
  ChatRoomScreen({super.key, required this.myData, required this.targetUser});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController messageController = TextEditingController();
  final database = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;
  ScrollController? scrollController;
  List<MessageModel> messageList = [];
  bool isFieldEmpty = true;
  bool showEmoji = false;

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
    return GestureDetector(
      onTap: () => unfocus(context),
      child: WillPopScope(
        onWillPop: () {
          if (showEmoji) {
            setState(() {
              showEmoji = !showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
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
                    "asset/whatsapp_bg/whatsapp_bg.png",
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
                              DateTime.parse(
                                  messageList[index].sentOn.toString()));

                          // if (messageList.isNotEmpty) {
                          //   scrollController!.animateTo(
                          //       scrollController!.position.maxScrollExtent,
                          //       duration: const Duration(milliseconds: 10),
                          //       curve: Curves.bounceIn);
                          // }

                          return Row(
                            mainAxisAlignment: messageList[index].senderId ==
                                    auth.currentUser!.uid
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width -
                                            100),
                                margin: EdgeInsets.only(
                                    bottom: 10,
                                    left: messageList[index].senderId ==
                                            auth.currentUser!.uid
                                        ? 0
                                        : 50,
                                    right: messageList[index].senderId ==
                                            auth.currentUser!.uid
                                        ? 50
                                        : 0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: messageList[index].senderId ==
                                          auth.currentUser!.uid
                                      ? const LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [whiteColor, whiteColor])
                                      : const LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [
                                              Color.fromARGB(
                                                  255, 255, 218, 220),
                                              chatTileColor
                                            ]),
                                  borderRadius:
                                      BorderRadius.circular(20).copyWith(
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
                                child: Wrap(
                                    alignment: WrapAlignment.end,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            messageList[index].senderId ==
                                                    auth.currentUser!.uid
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onLongPress: () =>
                                                FlutterClipboard.copy(
                                                    messageList[index].message),
                                            child: Text(
                                              messageList[index].message,
                                              style: TextThemeProvider
                                                  .bodyTextSecondary
                                                  .copyWith(
                                                      color: blackColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                          sizedBox(4),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                dateTime,
                                                style: TextThemeProvider
                                                    .helperText
                                                    .copyWith(
                                                        fontSize: 8,
                                                        color:
                                                            greyColor.shade800),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              messageList[index].senderId !=
                                                      auth.currentUser!.uid
                                                  ? messageList[index].seen
                                                      ? const Icon(
                                                          Icons.done_all,
                                                          color: primaryColor,
                                                          size: 15,
                                                        )
                                                      : const Icon(
                                                          Icons.check,
                                                          color: primaryColor,
                                                          size: 15,
                                                        )
                                                  : const SizedBox(),
                                            ],
                                          )
                                        ],
                                      ),
                                    ]),
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
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: TextFormField(
                              onTap: () {
                                unfocus(context);
                                if (showEmoji) {
                                  setState(() => showEmoji = !showEmoji);
                                }
                              },
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.attach_file_outlined,
                                              color: whiteColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.camera_alt,
                                              color: whiteColor,
                                            ),
                                          ],
                                        )
                                      : const Icon(
                                          Icons.attach_file_outlined,
                                          color: whiteColor,
                                        ),
                                  prefixIcon: InkWell(
                                    onTap: () {
                                      unfocus(context);
                                      setState(() => showEmoji = !showEmoji);
                                    },
                                    child: const Icon(
                                      Icons.emoji_emotions,
                                      color: whiteColor,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  hintText: "Message",
                                  hintStyle: TextThemeProvider.bodyTextSmall
                                      .copyWith(color: whiteColor)),
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
                                shape: BoxShape.circle, color: primaryColor),
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
                    ),
                    if (showEmoji)
                      SizedBox(
                        height: 300,
                        child: EmojiPicker(
                          textEditingController: messageController,
                          config: Config(
                            columns: 7,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          ),
                        ),
                      )
                  ],
                ),
              ],
            )),
      ),
    );
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
    await database
        .ref("ChatRooms/LastMessage/${widget.targetUser["UserId"]}/")
        .set({
      "LastMessage": messageController.text,
      "sentOn": DateTime.now().toIso8601String(),
    });
    messageController.clear();
    setState(() {
      isFieldEmpty = true;
    });

    await database
        .ref(
            "ChatRooms/${createChatRoomId(auth.currentUser!.uid, widget.targetUser["UserId"])}")
        .push()
        .set(bodyData);

    // Message Scroll In End of List
    scrollController!.animateTo(scrollController!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10), curve: Curves.ease);
  }
}
