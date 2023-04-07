import 'package:flutter/material.dart';

import '../../../helper/base_getters.dart';
import '../../../helper/global_function.dart';
import '../../../helper/styles/app_style_sheet.dart';

class GroupChatMessageTextField extends StatefulWidget {
  String groupChatId;

  GroupChatMessageTextField({required this.groupChatId, super.key});

  @override
  State<GroupChatMessageTextField> createState() =>
      _GroupChatMessageTextFieldState();
}

class _GroupChatMessageTextFieldState extends State<GroupChatMessageTextField> {
  ScrollController? scrollController;
  final messageController = TextEditingController();
  bool isFieldEmpty = false;
  bool showEmoji = false;

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
              style: GetTextTheme.sf16_regular
                  .copyWith(color: AppColors.whiteColor),
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
                                // File pickedFile = await pickImageWithGallery();
                                // var provider = Provider.of<GetterSetterModel>(
                                //     context,
                                //     listen: false);
                                // if (widget.chatRoomId.isNotEmpty) {
                                //   AppServices.pushTo(
                                //       context,
                                //       ChatImagePreview(
                                //         chatRoomId: widget.chatRoomId,
                                //         pickedFile: pickedFile,
                                //         targetUser: widget.targetUser,
                                //       ));
                                // } else {
                                //   AppServices.pushTo(
                                //       context,
                                //       ChatImagePreview(
                                //         chatRoomId: provider.getChatRoomId,
                                //         pickedFile: pickedFile,
                                //         targetUser: widget.targetUser,
                                //       ));
                                // }
                              },
                              child: const Icon(
                                Icons.attach_file_outlined,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            AppServices.addWidth(10),
                            InkWell(
                              onTap: () async {
                                // var provider = Provider.of<GetterSetterModel>(
                                //     context,
                                //     listen: false);
                                // File pickedImage = await pickImageWithCamera();
                                // if (widget.chatRoomId.isNotEmpty) {
                                //   AppServices.pushTo(
                                //     context,
                                //     ChatImagePreview(
                                //       chatRoomId: widget.chatRoomId,
                                //       pickedFile: pickedImage,
                                //       targetUser: widget.targetUser,
                                //     ),
                                //   );
                                // } else {
                                //   AppServices.pushTo(
                                //     context,
                                //     ChatImagePreview(
                                //       chatRoomId: provider.getChatRoomId,
                                //       pickedFile: pickedImage,
                                //       targetUser: widget.targetUser,
                                //     ),
                                //   );
                                // }
                              },
                              child: const Icon(
                                Icons.camera_alt,
                                color: AppColors.whiteColor,
                              ),
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
                      setState(() => showEmoji = !showEmoji);
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
                shape: BoxShape.circle, color: AppColors.primaryColor),
            child: isFieldEmpty
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
      "message": messageController.text,
      "senderId": auth.currentUser!.uid,
      // "msgStatus": "present",
      "seen": false,
      "sentOn": DateTime.now().toIso8601String(),
      "messageType": "text",
      "groupId": widget.groupChatId,
    };

    messageController.clear();
    setState(() {
      isFieldEmpty = true;
    });

    if (widget.groupChatId.isNotEmpty) {
      await database
          .ref("ChatRooms/${widget.groupChatId}")
          .child("Chats/")
          .push()
          .set(bodyData);
    }
  }
}
