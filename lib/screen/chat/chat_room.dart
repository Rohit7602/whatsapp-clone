// ignore_for_file: must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/screen/chat/show_chats.dart';
import '../../database_event/chat_event.dart';
import '../../function/custom_appbar.dart';
import '../../helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';
import '../../model/user_model.dart';

class ChatRoomScreen extends StatefulWidget {
  UserModel targetUser;
  String chatRoomId;

  ChatRoomScreen({
    super.key,
    required this.targetUser,
    required this.chatRoomId,
  });

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController messageController = TextEditingController();

  ScrollController? scrollController;
  bool isFieldEmpty = true;
  bool showEmoji = false;
  File? pickedFile;
  bool isLoading = false;

  @override
  void initState() {
    scrollController = ScrollController();

    chatEventListener();

    super.initState();
  }

  chatEventListener() async {
    if (!await rebuild()) return;
    var provider = Provider.of<GetterSetterModel>(context, listen: false);
    provider.removeChatRoomId();

    ChatEventListner(context: context, provider: provider)
        .getChatsMessageList(widget.chatRoomId);
    ChatEventListner(context: context, provider: provider)
        .isSeenMessages(widget.chatRoomId, widget.targetUser.userId);
    // ChatEventListner(context: context, provider: provider)
    //     .isSeenMessages(widget.chatRoomId, widget.targetUser.userId);
  }

  Future<bool> rebuild() async {
    if (!mounted) return false;
    // if there's a current frame,
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      // wait for the end of that frame.
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return false;
    }
    setState(() {});
    return true;
  }

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
                  Text(widget.targetUser.name),
                  AppServices.addHeight(2),
                  Text(widget.targetUser.status,
                      style: GetTextTheme.sf10_medium),
                ],
              ),
              action: [
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
              ShowChatOnScreen(
                  showEmoji: showEmoji,
                  isFieldEmpty: isFieldEmpty,
                  messageController: messageController,
                  targetUser: widget.targetUser,
                  pickedFile: pickedFile,
                  chatRoomId: widget.chatRoomId)
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

 