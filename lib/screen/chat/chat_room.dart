// ignore_for_file: library_private_types_in_public_api, must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/model/message_model.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';
import 'package:whatsapp_clone/widget/upload_image_db.dart';
import '../../styles/textTheme.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'chat_image_preview.dart';

File? getFutureImage;
TextEditingController? getCaptionController;

class ChatRoomScreen extends StatefulWidget {
  dynamic targetUser;
  ChatRoomScreen({super.key, required this.targetUser});

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
  File? pickedFile;
  bool isLoading = false;

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

    if (getFutureImage != null) {
      uploadFutureImageonDB();
    }

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

      database
          .ref(
              "ChatRooms/${createChatRoomId(auth.currentUser!.uid, widget.targetUser["UserId"])}")
          .onValue
          .listen(
        (event) async {
          var eventKey = event.snapshot.children.map((e) => e.key).toList();
          for (var element in eventKey) {
            var recieverId = await database
                .ref(
                    "ChatRooms/${createChatRoomId(auth.currentUser!.uid, widget.targetUser["UserId"])}/$element/senderId")
                .get();

            if (recieverId.value.toString() != auth.currentUser!.uid) {
              database
                  .ref(
                      "ChatRooms/${createChatRoomId(auth.currentUser!.uid, widget.targetUser["UserId"])}/$element/")
                  .update({
                "seen": true,
              });
            }
          }
        },
      );

      database
          .ref("users/${widget.targetUser["UserId"]}")
          .onValue
          .listen((event) {
        var eventSnapshot = event.snapshot.children.map((e) => e).toList();
        var getStatus =
            eventSnapshot.firstWhere((element) => element.key == "Status");
        var provider = Provider.of<GetterSetterModel>(context, listen: false);
        provider.getStatus(getStatus.value.toString());
      });
    });

    super.initState();
  }

  uploadFutureImageonDB() async {
    if (getCaptionController!.text.isEmpty) {
      setState(() {
        isLoading = true;
      });
      var downloadUrl = await uploadImageOnDb("ChatRooms", getFutureImage);
      setState(() {
        downloadUrl;
      });

      if (downloadUrl != null) {
        final database = FirebaseDatabase.instance;
        final auth = FirebaseAuth.instance;

        Map<String, dynamic> bodyData = {
          "message": downloadUrl,
          "caption": getCaptionController!.text,
          "senderId": auth.currentUser!.uid,
          "seen": false,
          "sentOn": DateTime.now().toIso8601String(),
          "messageType": "image",
        };

        getCaptionController!.clear();

        await database
            .ref(
                "ChatRooms/${createChatRoomId(auth.currentUser!.uid, widget.targetUser["UserId"])}")
            .push()
            .set(bodyData);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      null;
    }
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
              title: Column(
                children: [
                  Text(widget.targetUser["Name"]),
                  sizedBox(2),
                  Consumer<GetterSetterModel>(
                    builder: (context, data, child) {
                      return Text(data.getUserStatus,
                          style: TextThemeProvider.helperText);
                    },
                  )
                ],
              ),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "asset/whatsapp_bg/whatsapp_bg.png",
                    fit: BoxFit.cover,
                  ),
                ),
                showChatOnScreen(context),
              ],
            )),
      ),
    );
  }

  Column showChatOnScreen(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(8.0),
            itemCount: messageList.length,
            itemBuilder: (context, index) {
              var dateTime = DateFormat('hh:mm a')
                  .format(DateTime.parse(messageList[index].sentOn.toString()));

              // if (messageList.isNotEmpty) {
              //   scrollController!.animateTo(
              //       scrollController!.position.maxScrollExtent,
              //       duration: const Duration(milliseconds: 10),
              //       curve: Curves.bounceIn);
              // }

              return Row(
                mainAxisAlignment:
                    messageList[index].senderId == auth.currentUser!.uid
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 100),
                    margin: EdgeInsets.only(
                        bottom: 10,
                        left:
                            messageList[index].senderId == auth.currentUser!.uid
                                ? 50
                                : 4,
                        right:
                            messageList[index].senderId == auth.currentUser!.uid
                                ? 4
                                : 50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          messageList[index].senderId == auth.currentUser!.uid
                              ? chatTileColor
                              : whiteColor,
                      borderRadius: BorderRadius.circular(10).copyWith(
                        bottomRight:
                            messageList[index].senderId == auth.currentUser!.uid
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                        bottomLeft:
                            messageList[index].senderId == auth.currentUser!.uid
                                ? const Radius.circular(12)
                                : const Radius.circular(0),
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onLongPress: () => FlutterClipboard.copy(
                                  messageList[index].message),
                              child: messageList[index].messageType == "text"
                                  ? Text(
                                      messageList[index].message,
                                      style: TextThemeProvider.bodyTextSecondary
                                          .copyWith(
                                              color: blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                    )
                                  : messageList[index].messageType == "image"
                                      ? Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              height: 250,
                                              child: isLoading
                                                  ? showLoading()
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.network(
                                                        messageList[index]
                                                            .message,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  dateTime,
                                                  style: TextThemeProvider
                                                      .helperText
                                                      .copyWith(
                                                          fontSize: 8,
                                                          color: greyColor
                                                              .shade800),
                                                ),
                                                messageList[index].senderId ==
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
                                        )
                                      : const SizedBox(),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            messageList[index].messageType == "image"
                                ? const SizedBox()
                                : Text(
                                    dateTime,
                                    style: TextThemeProvider.helperText
                                        .copyWith(
                                            fontSize: 8,
                                            color: greyColor.shade800),
                                  ),
                            const SizedBox(
                              width: 6,
                            ),
                            messageList[index].messageType == "image"
                                ? const SizedBox()
                                : messageList[index].senderId ==
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
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        messageTextField(context),
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
    );
  }

  Row messageTextField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            margin: const EdgeInsets.only(
              left: 10,
              bottom: 10,
            ),
            height: 45,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(50)),
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
              style: TextThemeProvider.bodyText.copyWith(color: whiteColor),
              controller: messageController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: isFieldEmpty
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                pickedFile = await pickImageWithGallery();
                                setState(() {
                                  pickedFile;
                                });
                                popView(context);

                                pushTo(
                                    context,
                                    ChatImagePreview(
                                        chatRoomId: createChatRoomId(
                                            auth.currentUser!.uid,
                                            widget.targetUser["UserId"]),
                                        pickedFile: pickedFile));
                              },
                              child: const Icon(
                                Icons.attach_file_outlined,
                                color: whiteColor,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
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
    );
  }

  sendMessaage() async {
    Map<String, dynamic> bodyData = {
      "message": messageController.text,
      "senderId": auth.currentUser!.uid,
      "seen": false,
      "sentOn": DateTime.now().toIso8601String(),
      "messageType": "text",
    };

    messageController.clear();
    setState(() {
      isFieldEmpty = true;
    });

    await database
        .ref(
            "ChatRooms/${createChatRoomId(auth.currentUser!.uid, widget.targetUser["UserId"])}")
        .push()
        .set(bodyData);

    scrollController!.animateTo(scrollController!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10), curve: Curves.ease);
  }
}
