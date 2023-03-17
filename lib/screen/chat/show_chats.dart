// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import '../../model/user_model.dart';
import 'components/chat_message_field.dart';
import 'components/chats_basic.dart';
import '../../getter_setter/getter_setter.dart';
import '../../helper/styles/app_style_sheet.dart';
import 'package:whatsapp_clone/model/message_model.dart';

class ShowChatOnScreen extends StatefulWidget {
  bool showEmoji;
  bool isFieldEmpty;
  TextEditingController messageController;
  UserModel targetUser;
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
              var dateTime = DateFormat('hh:mm a')
                  .format(DateTime.parse(messageList[index].sentOn.toString()));

              return messageList[index].messageType == "text"
                  ? ShowTextChat(messageList, index, context, dateTime)
                  : ShowImageChat(provider, messageList, index, dateTime);
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

  Row ShowTextChat(List<MessageModel> messageList, int index,
      BuildContext context, String dateTime) {
    return Row(
      mainAxisAlignment: messageMainAlignment(messageList[index].senderId),
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
          margin: textMessageMargin(messageList[index].senderId),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: textMessageDecoration(messageList[index].senderId),
          child: Wrap(
            alignment: WrapAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      onLongPress: () =>
                          FlutterClipboard.copy(messageList[index].message),
                      child: Text(messageList[index].message,
                          style: GetTextTheme.sf14_medium)),
                  AppServices.addWidth(5),
                  messageList[index].messageType == "image"
                      ? const SizedBox()
                      : Text(
                          dateTime,
                          style: GetTextTheme.sf10_regular.copyWith(
                              fontSize: 8, color: AppColors.greyColor.shade800),
                        ),
                  AppServices.addWidth(6),
                  messageList[index].messageType == "image"
                      ? const SizedBox()
                      : isSendIdOrCurrentIdTrue(messageList[index].senderId)
                          ? messageList[index].seen
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
  }

  ShowImageChat(GetterSetterModel provider, List<MessageModel> messageList,
      int index, String dateTime) {
    return Row(
      mainAxisAlignment: messageMainAlignment(messageList[index].senderId),
      children: [
        Column(
          crossAxisAlignment:
              messageCrossAlignment(messageList[index].senderId),
          children: [
            provider.isLoading
                ? Shimmer(
                    direction: ShimmerDirection.ltr,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.greyColor.withOpacity(0.4),
                        AppColors.greyColor.withOpacity(0.4),
                        AppColors.whiteColor,
                        AppColors.whiteColor,
                        // AppColors.greyColor.withOpacity(0.4),
                        AppColors.greyColor.withOpacity(0.4)
                      ],
                      stops: const [0.0, 0.35, 0.2, 0.65, 0],
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      height: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          messageList[index].message,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ))
                : Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        messageList[index].message,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
            Container(
              alignment: messageAlignment(messageList[index].senderId),
              margin: textMessageMargin(messageList[index].senderId),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: isSendIdOrCurrentIdTrue(messageList[index].senderId)
                    ? AppColors.chatTileColor
                    : AppColors.whiteColor,
                borderRadius: isMessageCircular(messageList[index].senderId),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    dateTime,
                    style: GetTextTheme.sf10_regular.copyWith(
                        fontSize: 8, color: AppColors.greyColor.shade800),
                  ),
                  isSendIdOrCurrentIdTrue(messageList[index].senderId)
                      ? messageList[index].seen
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
            )
          ],
        ),
      ],
    );
  }
}
