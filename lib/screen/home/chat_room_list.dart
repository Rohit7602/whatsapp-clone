import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import '../../helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';

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
            // AppServices.pushTo(context,
            //     TemporaryScreen(chatroomId: targetuserModel[i].chatId));
            // AppServices.pushTo(
            //     context,
            //     ChatRoomScreen(
            //         targetUser: targetuserModel[i].userModel,
            //         chatRoomId: targetuserModel[i].chatId));
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
              targetuserModel[i].userModel.status == "online"
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
            targetuserModel[i].userModel.number,
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
                      ? const Text("Photo")
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
