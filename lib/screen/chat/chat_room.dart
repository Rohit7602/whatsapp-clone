// ignore_for_file: must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/helper/global_function.dart';
import 'package:whatsapp_clone/screen/chat/show_chats.dart';
import '../../components/Loader/full_screen_loader.dart';
import '../../components/custom_appbar.dart';
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
  bool isShowMessage = false;
  bool isSelected = false;

  @override
  void initState() {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);
    provider.updateChatRoomId("");
    provider.loadingState(false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
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
                  Consumer<GetterSetterModel>(
                    builder: (context, data, child) {
                      return data.chatRoomModel
                              .where((element) =>
                                  element.userModel!.userId ==
                                  widget.targetUser.userId)
                              .isEmpty
                          ? Text("comming soon..",
                              style: GetTextTheme.sf10_medium)
                          : Text(
                              data.chatRoomModel
                                  .firstWhere((element) =>
                                      element.userModel!.userId ==
                                      widget.targetUser.userId)
                                  .userModel!
                                  .status,
                              style: GetTextTheme.sf10_medium);
                    },
                  ),
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
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteInitChat(),
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
                chatRoomId: widget.chatRoomId,
                isSelected: isSelected,
                isShowMessage: isShowMessage,
              ),
              provider.isLoading ? const FullScreenLoader() : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  deleteInitChat() async {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);
    provider.loadingState(true);
    var getData = await database
        .ref("ChatRooms/${widget.chatRoomId}")
        .remove()
        .then((value) {
      provider.loadingState(false);
    });
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

 