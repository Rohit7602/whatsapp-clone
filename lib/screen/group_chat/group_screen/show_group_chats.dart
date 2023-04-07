// ignore_for_file: must_be_immutable, non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import '../../../helper/global_function.dart';
import '../../../helper/styles/app_style_sheet.dart';
import '../../chat/components/chats_basic.dart';
import 'package:whatsapp_clone/model/message_model.dart';

import 'group_chat_field.dart';

class ShowGroupChatOnScreen extends StatefulWidget {
  String groupId;

  ShowGroupChatOnScreen({required this.groupId, super.key, required});

  @override
  State<ShowGroupChatOnScreen> createState() => _ShowGroupChatOnScreenState();
}

class _ShowGroupChatOnScreenState extends State<ShowGroupChatOnScreen> {
  ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    print(widget.groupId);
    return Column(
      children: [
        Expanded(
            child: FirebaseAnimatedList(
                shrinkWrap: true,
                padding: const EdgeInsets.all(7),
                query: database.ref("ChatRooms/${widget.groupId}/Chats/"),
                itemBuilder: (context, snapshot, animation, i) {
                  final message = snapshot.value as Map<Object?, Object?>;

                  return message["messageType"].toString() == "text"
                      ? ShowTextChat(MessageModel.fromJson(
                          message, snapshot.key.toString()))
                      : ShowImageChat(MessageModel.fromJson(
                          message, snapshot.key.toString()));
                })),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GroupChatMessageTextField(
            groupChatId: widget.groupId,
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

  // String getMsgValue(msgState status, MessageModel msg) {
  //   if (status == msgState.present) {
  //     return msg.message;
  //   } else if (status == msgState.deleteForMe && msg == auth.currentUser!.uid) {
  //     return "This message is deleted by you";
  //   } else if (status == msgState.deleteForEveryone) {
  //     return "This message is deleted";
  //   } else {
  //     return "";
  //   }
  // }

  Widget ShowTextChat(MessageModel messageList) {
    var dateTime = DateFormat('hh:mm a')
        .format(DateTime.parse(messageList.sentOn.toString()));
    return InkWell(
      onTap: () {},
      // onLongPress: () {
      //   setState(() {
      //     widget.isSelected = true;
      //   });
      //   showDialog(
      //     context: context,
      //     builder: (context) {
      //       return DeleteChatMessage(
      //         msgModel: messageList[index],
      //         roomModel: groupId,
      //       );
      //     },
      //   );
      // },
      child: Row(
        mainAxisAlignment:
            messageMainAlignment(messageList.senderId.toString()),
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 100),
            margin: textMessageMargin(messageList.senderId.toString()),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: textMessageDecoration(messageList.senderId.toString()),
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onLongPress: () => FlutterClipboard.copy(
                            messageList.message.toString()),
                        child: Text(messageList.message.toString(),
                            style: GetTextTheme.sf14_medium)),
                    AppServices.addWidth(5),
                    messageList.messageType.toString() == "image"
                        ? const SizedBox()
                        : Text(
                            dateTime,
                            style: GetTextTheme.sf10_regular.copyWith(
                                fontSize: 8,
                                color: AppColors.greyColor.shade800),
                          ),
                    AppServices.addWidth(6),
                    isSendIdOrCurrentIdTrue(messageList.senderId.toString())
                        ? messageList.seen == true
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
                        : const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ShowImageChat(MessageModel messageList) {
    var dateTime = DateFormat('hh:mm a')
        .format(DateTime.parse(messageList.sentOn.toString()));

    return Row(
      mainAxisAlignment: messageMainAlignment(messageList.senderId),
      children: [
        Column(
          crossAxisAlignment: messageCrossAlignment(messageList.senderId),
          children: [
            Container(
              margin: textMessageMargin(messageList.senderId.toString()),
              height: AppServices.getScreenHeight(context) * 0.3,
              width: 180,
              decoration: BoxDecoration(
                borderRadius:
                    isMessageCircular(messageList.senderId.toString()),
              ),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageBuilder: (context, image) {
                    return Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.6),
                                  width: 2),
                              borderRadius: isMessageCircular(
                                  messageList.senderId.toString()),
                              image: DecorationImage(
                                  image: image, fit: BoxFit.cover)),
                        ),
                        Container(
                          height: 30,
                          width: 70,
                          alignment: messageAlignment(messageList.senderId),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.6),
                            ),
                            // boxShadow: const [
                            //   BoxShadow(
                            //       color: AppColors.chatTileColor,
                            //       blurRadius: 1),
                            //   BoxShadow(
                            //       color: AppColors.chatTileColor,
                            //       blurRadius: 1),
                            //   BoxShadow(
                            //       color: AppColors.chatTileColor,
                            //       blurRadius: 1),
                            // ],
                            color: isSendIdOrCurrentIdTrue(messageList.senderId)
                                ? AppColors.chatTileColor
                                : AppColors.whiteColor,
                            borderRadius:
                                isMessageCircular(messageList.senderId),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                dateTime,
                                style: GetTextTheme.sf10_regular.copyWith(
                                    fontSize: 8, color: AppColors.blackColor),
                              ),
                              AppServices.addWidth(5),
                              isSendIdOrCurrentIdTrue(messageList.senderId)
                                  ? messageList.seen == true
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
                        ),
                      ],
                    );
                  },
                  placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: AppColors.greyColor.shade200,
                        direction: ShimmerDirection.ltr,
                        child: Container(
                          height: 250,
                          decoration: const BoxDecoration(
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                  imageUrl: messageList.message.toString()),
            ),

            // Container(
            //   alignment: messageAlignment(messageList.senderId),
            //   margin: textMessageMargin(messageList.senderId),
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //   decoration: BoxDecoration(
            //     color: isSendIdOrCurrentIdTrue(messageList.senderId)
            //         ? AppColors.chatTileColor
            //         : AppColors.whiteColor,
            //     borderRadius: isMessageCircular(messageList.senderId),
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Text(
            //         dateTime,
            //         style: GetTextTheme.sf10_regular.copyWith(
            //             fontSize: 8, color: AppColors.greyColor.shade800),
            //       ),
            //       isSendIdOrCurrentIdTrue(messageList.senderId)
            //           ? messageList.seen == true
            //               ? const Icon(
            //                   Icons.done_all,
            //                   color: AppColors.primaryColor,
            //                   size: 15,
            //                 )
            //               : const Icon(
            //                   Icons.check,
            //                   color: AppColors.primaryColor,
            //                   size: 15,
            //                 )
            //           : const SizedBox(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}

// class DeleteChatMessage extends StatelessWidget {
//   MessageModel msgModel;
//   String roomModel;

//   DeleteChatMessage({
//     required this.msgModel,
//     required this.roomModel,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Delete Message"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextButton.icon(
//               onPressed: () {
//                 deleteMsg(msgModel, roomModel);

//                 AppServices.popView(context);
//               },
//               icon: const Icon(Icons.delete),
//               label: const Text("Delete Now")),
//         ],
//       ),
//     );
//   }
// }

// deleteMsg(MessageModel msg, String room) async {
//   await database
//       .ref("ChatRooms/$room/Chats/${msg.messageId}")
//       .update({"msgStatus": msgState.deleteForMe.name});
// }
