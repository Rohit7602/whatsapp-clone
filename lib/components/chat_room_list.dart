import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';

import '../screen/chat/chat_room.dart';
import '../styles/stylesheet.dart';
import '../styles/textTheme.dart';
import '../widget/custom_widget.dart';

class ChatRoomList extends StatelessWidget {
  const ChatRoomList({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<GetterSetterModel>(context);
    return ListView.separated(
      separatorBuilder: (context, i) => getHeight(15),
      shrinkWrap: true,
      itemCount: data.targetUserModel.length,
      itemBuilder: (context, i) {
        String dateTime = "";
        if (data.targetUserModel[i].messageModel.sentOn
            .toIso8601String()
            .isNotEmpty) {
          dateTime = DateFormat('hh:mm a').format(DateTime.parse(
              data.targetUserModel[i].messageModel.sentOn.toString()));
        }

        return ListTile(
          onTap: () {
            pushTo(
                context,
                ChatRoomScreen(
                    targetUser: data.targetUserModel[i].userModel.userId));
          },
          leading: Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: lightGreyColor),
            child: data.targetUserModel[i].userModel.profileImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      data.targetUserModel[i].userModel.profileImage,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 35,
                    color: whiteColor,
                  ),
          ),
          title: Text(
            data.targetUserModel[i].userModel.number,
          ),
          subtitle: Row(
            children: [
              data.targetUserModel[i].messageModel.seen
                  ? const Icon(
                      Icons.done_all,
                      color: primaryColor,
                      size: 15,
                    )
                  : const Icon(
                      Icons.check,
                      color: primaryColor,
                      size: 15,
                    ),
              const SizedBox(
                width: 3,
              ),
              data.targetUserModel[i].messageModel.message.isEmpty
                  ? const Text("Start Chat")
                  : data.targetUserModel[i].messageModel.messageType == 'image'
                      ? const Text("Photo")
                      : data.targetUserModel[i].messageModel.messageType ==
                              "text"
                          ? Text(data.targetUserModel[i].messageModel.message)
                          : const Text("coming, soon"),
            ],
          ),
          trailing: Text(
            dateTime.toString(),
            style: TextThemeProvider.bodyTextSecondary
                .copyWith(color: greyColor, fontSize: 12),
          ),
        );
      },
    );
  }
}
