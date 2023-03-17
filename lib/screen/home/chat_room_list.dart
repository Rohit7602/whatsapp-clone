import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import '../../helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';
import '../chat/chat_room.dart';

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({super.key});

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
    var targetuserModel = provider.targetUserModel;
    return ListView.separated(
      separatorBuilder: (context, i) => AppServices.addHeight(15),
      shrinkWrap: true,
      itemCount: targetuserModel.length,
      itemBuilder: (context, i) {
        var dateTime = DateFormat('hh:mm a').format(
            DateTime.parse(targetuserModel[i].messageModel.sentOn.toString()));

        return ListTile(
          onTap: () {
            AppServices.pushTo(
                context,
                ChatRoomScreen(
                    targetUser: targetuserModel[i].userModel,
                    chatRoomId: targetuserModel[i].chatRoomId));
          },
          leading: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.lightGreyColor),
            child: targetuserModel[i].userModel.profileImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      targetuserModel[i].userModel.profileImage,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 35,
                    color: AppColors.whiteColor,
                  ),
          ),
          title: Text(
            targetuserModel[i].userModel.number,
          ),
          subtitle: Row(
            children: [
              targetuserModel[i].messageModel.seen
                  ? const Icon(
                      Icons.done_all,
                      color: AppColors.primaryColor,
                      size: 15,
                    )
                  : const Icon(
                      Icons.check,
                      color: AppColors.primaryColor,
                      size: 15,
                    ),
              const SizedBox(
                width: 3,
              ),
              targetuserModel[i].messageModel.message.isEmpty
                  ? const Text("Start Chat")
                  : targetuserModel[i].messageModel.messageType == 'image'
                      ? const Text("Photo")
                      : targetuserModel[i].messageModel.messageType == "text"
                          ? Text(targetuserModel[i].messageModel.message)
                          : const Text("coming, soon"),
            ],
          ),
          trailing: Text(
            dateTime.toString(),
            style:
                GetTextTheme.sf12_medium.copyWith(color: AppColors.greyColor),
          ),
        );
      },
    );
  }
}
