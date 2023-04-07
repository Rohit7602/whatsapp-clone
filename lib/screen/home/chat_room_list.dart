import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/screen/group_chat/group_screen/group_chatroom.dart';
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
    var targetuserModel = provider.chatRoomModel;
    return ListView.separated(
      separatorBuilder: (context, i) => AppServices.addHeight(15),
      shrinkWrap: true,
      itemCount: targetuserModel.length,
      itemBuilder: (context, i) {
        var dateTime = DateFormat('hh:mm a')
            .format(DateTime.parse(targetuserModel[i].sentOn.toString()));

        return ListTile(
          onTap: () {
            targetuserModel[i].userModel == null
                ? AppServices.pushTo(
                    context,
                    GroupChatRoomScreen(
                        groupName: targetuserModel[i].groupModel!.groupName,
                        groupId: targetuserModel[i].groupModel!.groupId))
                : AppServices.pushTo(
                    context,
                    ChatRoomScreen(
                        targetUser: targetuserModel[i].userModel!,
                        chatRoomId: targetuserModel[i].chatId.isEmpty
                            ? targetuserModel[i].groupModel!.groupId
                            : targetuserModel[i].chatId));
          },
          leading: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.greyColor.shade200, width: 1.2),
                      shape: BoxShape.circle,
                      color: AppColors.lightGreyColor),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: targetuserModel[i].userModel != null
                          ? Image.network(
                              targetuserModel[i].userModel!.profileImage,
                              fit: BoxFit.cover,
                            )
                          : targetuserModel[i].groupModel != null
                              ? Image.network(
                                  targetuserModel[i].groupModel!.groupImage,
                                )
                              : const Icon(Icons.person))),
              targetuserModel[i].userModel == null
                  ? const SizedBox()
                  : targetuserModel[i].userModel!.status == "online"
                      ? Positioned(
                          bottom: 3,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.greyColor.shade200,
                                    width: 1.5),
                                shape: BoxShape.circle,
                                color: AppColors.lightGreenColor),
                          ),
                        )
                      : const SizedBox(),
            ],
          ),
          title: Text(
            targetuserModel[i].userModel == null
                ? targetuserModel[i].groupModel!.groupName
                : targetuserModel[i].userModel!.number,
          ),
          subtitle: Row(
            children: [
              targetuserModel[i].seen
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
              targetuserModel[i].message.isEmpty
                  ? const Text("Start Chat")
                  : targetuserModel[i].messageType == 'image'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(AppImages.photoIcon, width: 15),
                            AppServices.addWidth(5),
                            const Text("Photo"),
                          ],
                        )
                      : targetuserModel[i].messageType == "text"
                          ? Text(targetuserModel[i].message)
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
