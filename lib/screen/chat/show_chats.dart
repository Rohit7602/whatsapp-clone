// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import '../../database_event/chat_event.dart';
import 'components/chat_message_field.dart';
import '../../components/show_loading.dart';
import 'components/chats_basic.dart';
import '../../getter_setter/getter_setter.dart';
import '../../helper/global_function.dart';
import '../../helper/styles/app_style_sheet.dart';

class ShowChatOnScreen extends StatefulWidget {
  bool showEmoji;
  bool isFieldEmpty;
  TextEditingController messageController;
  String targetUser;
  File? pickedFile;
  String chatRoomId;
  ShowChatOnScreen(
      {required this.showEmoji,
      required this.isFieldEmpty,
      required this.messageController,
      required this.targetUser,
      required this.pickedFile,
      required this.chatRoomId,
      super.key});

  @override
  State<ShowChatOnScreen> createState() => _ShowChatOnScreenState();
}

class _ShowChatOnScreenState extends State<ShowChatOnScreen> {
  ScrollController? scrollController;

  @override
  void initState() {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);

    ChatEventListner(context: context, provider: provider)
        .getChatsMessageList(widget.chatRoomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
    var messageList = provider.messageModel;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(8),
            itemCount: messageList.length,
            itemBuilder: (context, index) {
              var senderId = messageList[index].senderId;
              var message = messageList[index].message;
              var messageType = messageList[index].messageType;
              var messageSeen = messageList[index].seen;
              var dateTime = DateFormat('hh:mm a')
                  .format(DateTime.parse(messageList[index].sentOn.toString()));

              return Row(
                mainAxisAlignment: messageAlignment(senderId),
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 100),
                    margin: EdgeInsets.only(
                        bottom: 10,
                        left: isSendIdOrCurrentIdTrue(senderId) ? 50 : 4,
                        right: isSendIdOrCurrentIdTrue(senderId) ? 4 : 50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSendIdOrCurrentIdTrue(senderId)
                          ? AppColors.chatTileColor
                          : AppColors.whiteColor,
                      borderRadius: isMessageCircular().copyWith(
                        bottomRight: isSendIdOrCurrentIdTrue(senderId)
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                        bottomLeft: senderId == auth.currentUser!.uid
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
                              onLongPress: () => FlutterClipboard.copy(message),
                              child: messageType == "text"
                                  ? Text(messageList[index].message,
                                      style: GetTextTheme.sf14_medium)
                                  : messageType == "image"
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
                                                  style: GetTextTheme
                                                      .sf10_regular
                                                      .copyWith(
                                                          fontSize: 8,
                                                          color: AppColors
                                                              .greyColor
                                                              .shade800),
                                                ),
                                                isSendIdOrCurrentIdTrue(
                                                        senderId)
                                                    ? messageSeen
                                                        ? const Icon(
                                                            Icons.done_all,
                                                            color: AppColors
                                                                .primaryColor,
                                                            size: 15,
                                                          )
                                                        : const Icon(
                                                            Icons.check,
                                                            color: AppColors
                                                                .primaryColor,
                                                            size: 15,
                                                          )
                                                    : const SizedBox(),
                                              ],
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                            ),
                            AppServices.addWidth(5),
                            messageType == "image"
                                ? const SizedBox()
                                : Text(
                                    dateTime,
                                    style: GetTextTheme.sf10_regular.copyWith(
                                        fontSize: 8,
                                        color: AppColors.greyColor.shade800),
                                  ),
                            AppServices.addWidth(6),
                            messageType == "image"
                                ? const SizedBox()
                                : isSendIdOrCurrentIdTrue(senderId)
                                    ? messageSeen
                                        ? const Icon(
                                            Icons.done_all,
                                            color: AppColors.primaryColor,
                                            size: 15,
                                          )
                                        : const Icon(
                                            Icons.check,
                                            color: AppColors.primaryColor,
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
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ChatMessageTextField(
            showEmoji: widget.showEmoji,
            isFieldEmpty: widget.isFieldEmpty,
            messageController: widget.messageController,
            targetUser: widget.targetUser,
            pickedFile: widget.pickedFile,
            chatRoomId: widget.chatRoomId,
          ),
        ),
        // if (widget.showEmoji)
        //   SizedBox(
        //     height: 300,
        //     child: EmojiPicker(
        //       textEditingController: widget.messageController,
        //       config: Config(
        //         columns: 7,
        //         emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        //       ),
        //     ),
        //   )
      ],
    );
  }
}
