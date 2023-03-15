// ignore_for_file: must_be_immutable, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/components/upload_image_db.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import '../../../helper/global_function.dart';
import '../../../helper/styles/app_style_sheet.dart';

class ChatMessageTextField extends StatefulWidget {
  bool showEmoji;
  bool isFieldEmpty;
  TextEditingController messageController;
  String targetUser;
  File? pickedFile;
  String chatRoomId;
  ChatMessageTextField(
      {required this.showEmoji,
      required this.isFieldEmpty,
      required this.messageController,
      required this.targetUser,
      required this.pickedFile,
      required this.chatRoomId,
      super.key});

  @override
  State<ChatMessageTextField> createState() => _ChatMessageTextFieldState();
}

class _ChatMessageTextFieldState extends State<ChatMessageTextField> {
  String myChatRoomID = "";
  ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(50)),
            child: TextFormField(
              onTap: () {
                AppServices.keyboardUnfocus(context);
                if (widget.showEmoji) {
                  setState(() => widget.showEmoji = !widget.showEmoji);
                }
              },
              onChanged: (v) {
                if (v.isEmpty) {
                  setState(() {
                    widget.isFieldEmpty = true;
                  });
                } else {
                  setState(() {
                    widget.isFieldEmpty = false;
                  });
                }
              },
              style: GetTextTheme.sf16_regular
                  .copyWith(color: AppColors.whiteColor),
              controller: widget.messageController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: widget.isFieldEmpty
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                widget.pickedFile =
                                    await pickImageWithGallery();
                                setState(() {
                                  widget.pickedFile;
                                });

                                // Navigator.of(context).pop();
                                // pushTo(
                                //     context,
                                //     ChatImagePreview(
                                //         chatRoomId: createChatRoomId(
                                //             auth.currentUser!.uid,
                                //             widget.targetUser.userModel.userId),
                                //         pickedFile: pickedFile));
                              },
                              child: const Icon(
                                Icons.attach_file_outlined,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.camera_alt,
                              color: AppColors.whiteColor,
                            ),
                          ],
                        )
                      : const Icon(
                          Icons.attach_file_outlined,
                          color: AppColors.whiteColor,
                        ),
                  prefixIcon: InkWell(
                    onTap: () {
                      AppServices.keyboardUnfocus(context);
                      setState(() => widget.showEmoji = !widget.showEmoji);
                    },
                    child: const Icon(
                      Icons.emoji_emotions,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  hintText: "Message",
                  hintStyle: GetTextTheme.sf14_regular
                      .copyWith(color: AppColors.whiteColor)),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (widget.messageController.text.isNotEmpty) {
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
                shape: BoxShape.circle, color: AppColors.primaryColor),
            child: widget.isFieldEmpty
                ? const Icon(
                    Icons.keyboard_voice_rounded,
                    color: AppColors.whiteColor,
                    size: 25,
                  )
                : const Icon(
                    Icons.send,
                    color: AppColors.whiteColor,
                    size: 20,
                  ),
          ),
        ),
      ],
    );
  }

  sendMessaage() async {
    Map<String, dynamic> bodyData = {
      "message": widget.messageController.text,
      "senderId": auth.currentUser!.uid,
      "seen": false,
      "sentOn": DateTime.now().toIso8601String(),
      "messageType": "text",
      "users": [auth.currentUser!.uid, widget.targetUser]
    };

    // widget.messageController.clear();
    setState(() {
      widget.isFieldEmpty = true;
    });

    if (widget.chatRoomId.isNotEmpty) {
      print("if Case");
      await database
          .ref("ChatRooms/${widget.chatRoomId}")
          .child("Chats/")
          .push()
          .set(bodyData);
    } else if (myChatRoomID.isNotEmpty) {
      print("if 2nd Case");
      await database
          .ref("ChatRooms/$myChatRoomID")
          .child("Chats/")
          .push()
          .set(bodyData);
    } else {
      print("else Case");
      await database
          .ref("ChatRooms/")
          .push()
          .child("Chats/")
          .push()
          .set(bodyData)
          .then((value) async {
        var getChatRoom = await database.ref("ChatRooms/").get();

        var getMyChatRoomId =
            getChatRoom.children.map((e) => e.key.toString()).toList().last;
        setState(() {
          myChatRoomID = getMyChatRoomId;
        });

        await database
            .ref("users/${auth.currentUser!.uid}/Mychatrooms/$getMyChatRoomId/")
            .set({"ChatId": getMyChatRoomId});
        await database
            .ref("users/${widget.targetUser}/Mychatrooms/$getMyChatRoomId/")
            .set({"ChatId": getMyChatRoomId});
      });
    }

    // scrollController!.animateTo(scrollController!.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 10), curve: Curves.ease);
  }
}
