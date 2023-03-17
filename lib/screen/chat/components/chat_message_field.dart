// ignore_for_file: must_be_immutable, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/components/upload_image_db.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import '../../../helper/global_function.dart';
import '../../../helper/styles/app_style_sheet.dart';
import '../../../model/user_model.dart';
import '../chat_image_preview.dart';

class ChatMessageTextField extends StatefulWidget {
  bool showEmoji;
  bool isFieldEmpty;
  TextEditingController messageController;
  UserModel targetUser;
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

                                AppServices.pushTo(
                                    context,
                                    ChatImagePreview(
                                      chatRoomId: widget.chatRoomId,
                                      pickedFile: widget.pickedFile,
                                      targetUser: widget.targetUser,
                                    ));
                              },
                              child: const Icon(
                                Icons.attach_file_outlined,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            AppServices.addWidth(10),
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
      "recieverId": widget.targetUser,
      "seen": false,
      "sentOn": DateTime.now().toIso8601String(),
      "messageType": "text",
      "users": [auth.currentUser!.uid, widget.targetUser]
    };

    widget.messageController.clear();
    setState(() {
      widget.isFieldEmpty = true;
    });

    var provider = Provider.of<GetterSetterModel>(context, listen: false);

    if (provider.getChatRoomId!.isNotEmpty) {
      await database
          .ref("ChatRooms/${provider.getChatRoomId}")
          .child("Chats/")
          .push()
          .set(bodyData);
    } else {
      if (widget.chatRoomId.isNotEmpty) {
        await database
            .ref("ChatRooms/${widget.chatRoomId}")
            .child("Chats/")
            .push()
            .set(bodyData);
      } else {
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
            provider.updateChatRoomId(getMyChatRoomId);
          });

          await database
              .ref(
                  "users/${auth.currentUser!.uid}/Mychatrooms/$getMyChatRoomId/")
              .set({"ChatId": getMyChatRoomId});
          await database
              .ref("users/${widget.targetUser}/Mychatrooms/$getMyChatRoomId/")
              .set({"ChatId": getMyChatRoomId});
        });
      }
    }

    // scrollController!.animateTo(scrollController!.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 10), curve: Curves.ease);
  }
}
