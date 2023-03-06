import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/chat_message_field.dart';
import '../../getter_setter/getter_setter.dart';
import '../../styles/stylesheet.dart';
import '../../styles/textTheme.dart';
import '../../widget/custom_instance.dart';
import '../../widget/custom_widget.dart';

class ShowChatOnScreen extends StatefulWidget {
  bool showEmoji;
  bool isFieldEmpty;
  TextEditingController messageController;
  String targetUser;
  File? pickedFile;
  ShowChatOnScreen(
      {required this.showEmoji,
      required this.isFieldEmpty,
      required this.messageController,
      required this.targetUser,
      required this.pickedFile,
      super.key});

  @override
  State<ShowChatOnScreen> createState() => _ShowChatOnScreenState();
}

class _ShowChatOnScreenState extends State<ShowChatOnScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
    var messageList = provider.messageModel;
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
                                              child: provider.isLoading
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
        MessageTextField(
            showEmoji: widget.showEmoji,
            isFieldEmpty: widget.isFieldEmpty,
            messageController: widget.messageController,
            targetUser: widget.targetUser,
            pickedFile: widget.pickedFile),
        if (widget.showEmoji)
          SizedBox(
            height: 300,
            child: EmojiPicker(
              textEditingController: widget.messageController,
              config: Config(
                columns: 7,
                emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
              ),
            ),
          )
      ],
    );
  }
}
