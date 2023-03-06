import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/textTheme.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';

import '../styles/stylesheet.dart';
import '../widget/create_chatroom.dart';
import '../widget/custom_instance.dart';
import '../widget/upload_image_db.dart';

class MessageTextField extends StatefulWidget {
  bool showEmoji;
  bool isFieldEmpty;
  TextEditingController messageController;
  String targetUser;
  File? pickedFile;
  MessageTextField(
      {required this.showEmoji,
      required this.isFieldEmpty,
      required this.messageController,
      required this.targetUser,
      required this.pickedFile,
      super.key});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  @override
  void initState() {
    scrollController = ScrollController();

    super.initState();
  }

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
                color: primaryColor, borderRadius: BorderRadius.circular(50)),
            child: TextFormField(
              onTap: () {
                unfocus(context);
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
              style: TextThemeProvider.bodyText.copyWith(color: whiteColor),
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
                      setState(() => widget.showEmoji = !widget.showEmoji);
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
                shape: BoxShape.circle, color: primaryColor),
            child: widget.isFieldEmpty
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
      "message": widget.messageController.text,
      "senderId": auth.currentUser!.uid,
      "seen": false,
      "sentOn": DateTime.now().toIso8601String(),
      "messageType": "text",
    };

    widget.messageController.clear();
    setState(() {
      widget.isFieldEmpty = true;
    });

    await database
        .ref(
            "ChatRooms/${createChatRoomId(auth.currentUser!.uid, widget.targetUser)}")
        .push()
        .set(bodyData);

    scrollController!.animateTo(scrollController!.position.maxScrollExtent,
        duration: const Duration(milliseconds: 10), curve: Curves.ease);
  }
}
