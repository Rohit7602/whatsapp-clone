// ignore_for_file: must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screen/group_chat/group_screen/show_group_chats.dart';

import '../../../components/custom_appbar.dart';
import '../../../helper/base_getters.dart';
import '../../../helper/styles/app_style_sheet.dart';

class GroupChatRoomScreen extends StatefulWidget {
  String groupName;
  String groupId;
  GroupChatRoomScreen({
    required this.groupName,
    required this.groupId,
    super.key,
  });

  @override
  _GroupChatRoomScreenState createState() => _GroupChatRoomScreenState();
}

class _GroupChatRoomScreenState extends State<GroupChatRoomScreen> {
  ScrollController? scrollController;
  bool showEmoji = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppServices.keyboardUnfocus(context),
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
          appBar: customAppBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("New Group"),
                  AppServices.addHeight(2),
                ],
              ),
              action: isSelected
                  ? [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.arrow_back)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete)),
                    ]
                  : [
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
                    ]),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppImages.whatsappBG,
                fit: BoxFit.cover,
              ),
              ShowGroupChatOnScreen(
                groupId: widget.groupId,
              )
            ],
          ),
        ),
      ),
    );
  }
}

  // if (showEmoji)
        //   SizedBox(
        //     height: 300.h,
        //     child: EmojiPicker(
        //       textEditingController: messageController,
        //       config: Config(
        //         columns: 7,
        //         emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        //       ),
        //     ),
        //   )

 