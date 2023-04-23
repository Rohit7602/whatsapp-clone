// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import '../../components/upload_image_db.dart';
import '../../components/custom_appbar.dart';
import '../../helper/base_getters.dart';
import '../../helper/global_function.dart';
import '../../helper/styles/app_style_sheet.dart';
import '../../model/user_model.dart';

class ChatImagePreview extends StatefulWidget {
  String chatRoomId;
  File? pickedFile;
  UserModel targetUser;
  ChatImagePreview(
      {required this.chatRoomId,
      required this.pickedFile,
      required this.targetUser,
      super.key});
  @override
  State<ChatImagePreview> createState() => _ChatImagePreviewState();
}

class _ChatImagePreviewState extends State<ChatImagePreview> {
  final captionController = TextEditingController();
  bool showEmoji = false;
  String downloadUrl = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: customAppBar(
        leading: IconButton(
            onPressed: () {
              widget.pickedFile = null;
              AppServices.popView(context);
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.whiteColor,
            )),
        title: const Text(""),
        color: AppColors.blackColor,
        action: [IconButton(onPressed: () {}, icon: const Icon(Icons.crop))],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.78,
        width: MediaQuery.of(context).size.width,
        child: Image.file(
          File(
            widget.pickedFile!.path,
          ),
          fit: BoxFit.contain,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
            top: 15,
            right: 10,
            left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
                    color: AppColors.lightGreyColor,
                    borderRadius: BorderRadius.circular(50)),
                child: TextFormField(
                  onTap: () {
                    AppServices.keyboardUnfocus(context);
                    if (showEmoji) {
                      setState(() => showEmoji = !showEmoji);
                    }
                  },
                  onChanged: (v) {
                    if (v.isEmpty) {}
                  },
                  style: GetTextTheme.sf16_regular
                      .copyWith(color: AppColors.whiteColor),
                  controller: captionController,
                  decoration: InputDecoration(
                    hintText: "Type a caption..",
                    hintStyle: GetTextTheme.sf14_regular
                        .copyWith(color: AppColors.greyColor.shade200),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.image,
                      color: AppColors.greyColor.shade200,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () async {
                if (captionController.text.isEmpty) {
                  setState(() {
                    isLoading = true;
                  });
                  downloadUrl =
                      await uploadImageOnDb("ChatRooms", widget.pickedFile);
                  setState(() {
                    downloadUrl;
                  });

                  if (downloadUrl.isNotEmpty) {
                    onImageSend();
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                  }
                } else {
                  null;
                }
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.primaryColor),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: AppColors.whiteColor,
                      )
                    : const Icon(
                        Icons.send,
                        color: AppColors.whiteColor,
                        size: 25,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onImageSend() async {
    Map<String, dynamic> bodyData = {
      "message": downloadUrl,
      "caption": captionController.text,
      "senderId": auth.currentUser!.uid,
      "seen": false,
      "sentOn": DateTime.now().toIso8601String(),
      "messageType": "image",
      "users": [auth.currentUser!.uid, widget.targetUser.userId]
    };

    captionController.clear();

    await database
        .ref("ChatRooms/${widget.chatRoomId}")
        .child("Chats/")
        .push()
        .set(bodyData);

    setState(() {
      isLoading = false;
    });
    AppServices.popView(context);
  }
}
