// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/screen/chat/show_chats.dart';
import '../../database_event/chat_event.dart';
import '../../function/custom_appbar.dart';
import '../../function/is_chatroom_available.dart';
import '../../helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';

File? getFutureImage;
TextEditingController? getCaptionController;

class ChatRoomScreen extends StatefulWidget {
  String targetUser;
  ChatRoomScreen({super.key, required this.targetUser});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController messageController = TextEditingController();
  final database = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;
  ScrollController? scrollController;
  bool isFieldEmpty = true;
  bool showEmoji = false;
  File? pickedFile;
  bool isLoading = false;
  String myChatRoomID = "";

  @override
  void initState() {
    scrollController = ScrollController();

    initFunction();
    super.initState();
  }

  initFunction() async {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);
    await isChatRoomAvailable(widget.targetUser).then((value) {
      setState(() => myChatRoomID = value);
      ChatEventListner(context: context, provider: provider)
          .getChatsMessageList(value);
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).viewInsets.bottom);
    var provider = Provider.of<GetterSetterModel>(context);
    var messageList = provider.messageModel;
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
          // resizeToAvoidBottomInset: true,
          appBar: customAppBar(
              title: Column(
                children: [
                  const Text("Rohit"),
                  AppServices.addHeight(2),
                  Consumer<GetterSetterModel>(
                    builder: (context, data, child) {
                      return Text(data.getUserStatus,
                          style: GetTextTheme.sf10_medium);
                    },
                  ),
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
                chatRoomId: myChatRoomID,
              )
            ],
          ),
        ),
      ),
    );
  }
}

  // if (widget.showEmoji)
        //   SizedBox(
        //     height: 300.h,
        //     child: EmojiPicker(
        //       textEditingController: widget.messageController,
        //       config: Config(
        //         columns: 7,
        //         emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        //       ),
        //     ),
        //   )

 // uploadFutureImageonDB() async {
  //   if (getCaptionController!.text.isEmpty) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     var downloadUrl = await uploadImageOnDb("ChatRooms", getFutureImage);
  //     setState(() {
  //       downloadUrl;
  //     });

  //     if (downloadUrl != null) {
  //       final database = FirebaseDatabase.instance;
  //       final auth = FirebaseAuth.instance;

  //       Map<String, dynamic> bodyData = {
  //         "message": downloadUrl,
  //         "caption": getCaptionController!.text,
  //         "senderId": auth.currentUser!.uid,
  //         "seen": false,
  //         "sentOn": DateTime.now().toIso8601String(),
  //         "messageType": "image",
  //       };

  //       getCaptionController!.clear();

  //       await database
  //           .ref("ChatRooms/${widget.targetUser}")
  //           .push()
  //           .set(bodyData);
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } else {
  //     null;
  //   }
  // }