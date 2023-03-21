import 'package:flutter/cupertino.dart';
import 'package:whatsapp_clone/helper/global_function.dart';

import '../../../helper/styles/app_style_sheet.dart';

MainAxisAlignment messageMainAlignment(senderId) {
  return isSendIdOrCurrentIdTrue(senderId)
      ? MainAxisAlignment.end
      : MainAxisAlignment.start;
}

CrossAxisAlignment messageCrossAlignment(senderId) {
  return isSendIdOrCurrentIdTrue(senderId)
      ? CrossAxisAlignment.end
      : CrossAxisAlignment.start;
}

AlignmentGeometry messageAlignment(senderId) {
  return isSendIdOrCurrentIdTrue(senderId)
      ? Alignment.centerRight
      : Alignment.centerLeft;
}

Decoration textMessageDecoration(senderId) {
  return BoxDecoration(
    color: isSendIdOrCurrentIdTrue(senderId)
        ? AppColors.chatTileColor
        : AppColors.whiteColor,
    borderRadius: isMessageCircular(senderId).copyWith(
      bottomRight: isSendIdOrCurrentIdTrue(senderId)
          ? const Radius.circular(0)
          : const Radius.circular(12),
      bottomLeft: isSendIdOrCurrentIdTrue(senderId)
          ? const Radius.circular(12)
          : const Radius.circular(0),
    ),
  );
}

EdgeInsetsGeometry textMessageMargin(senderId) {
  return EdgeInsets.only(
      bottom: 10,
      left: isSendIdOrCurrentIdTrue(senderId) ? 50 : 4,
      right: isSendIdOrCurrentIdTrue(senderId) ? 4 : 50);
}

bool isSendIdOrCurrentIdTrue(senderId) {
  return senderId == auth.currentUser!.uid;
}

BorderRadius isMessageCircular(senderId) {
  return BorderRadius.circular(10).copyWith(
    bottomRight: isSendIdOrCurrentIdTrue(senderId)
        ? const Radius.circular(0)
        : const Radius.circular(12),
    bottomLeft: isSendIdOrCurrentIdTrue(senderId)
        ? const Radius.circular(12)
        : const Radius.circular(0),
  );
}

// getChatRoomId(BuildContext context, String chatRoomId) {
//   var provider = Provider.of<GetterSetterModel>(context, listen: false);
//   if (!mounted) {
    
//   }
//   if (chatRoomId.isNotEmpty) {
//     provider.updateShowMessage(true);

//     print("1st Case ");

//     return database.ref("ChatRooms/$chatRoomId/Chats");
//   } else if (provider.getChatRoomId != null) {
//     provider.updateShowMessage(true);

//     print("2nd  Case ");

//     return database.ref("ChatRooms/${provider.getChatRoomId}/Chats");
//   } else {
//     print("3rd Case ");
//     provider.updateShowMessage(false);
//   }
// }
