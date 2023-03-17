import 'package:whatsapp_clone/model/user_model.dart';

import 'message_model.dart';

class TargetUserModel {
  String chatRoomId;
  String messageId;
  MessageModel messageModel;
  UserModel userModel;

  TargetUserModel({
    required this.chatRoomId,
    required this.messageId,
    required this.messageModel,
    required this.userModel,
  });

  TargetUserModel.fromJson(
      {required this.chatRoomId,
      required this.messageId,
      required this.messageModel,
      required this.userModel});
}
