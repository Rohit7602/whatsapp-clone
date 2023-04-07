import 'package:whatsapp_clone/model/user_model.dart';

import 'group_model.dart';

class ChatRoomModel {
  String chatId;
  String messageId;
  DateTime sentOn;
  String message;
  String messageType;
  UserModel? userModel;
  GroupChatModel? groupModel;

  List<Object>? users;
  bool seen;
  ChatRoomModel(
      {required this.chatId,
      required this.messageId,
      required this.sentOn,
      required this.message,
      this.userModel,
      this.groupModel,
      required this.messageType,
      this.users,
      required this.seen});
  ChatRoomModel.fromJson(
      {required Map<Object?, Object?> json,
      required this.messageId,
      required this.chatId,
      this.userModel,
      this.groupModel,
      this.users})
      : sentOn = DateTime.parse(json["sentOn"].toString()),
        message = json["message"].toString(),
        messageType = json["messageType"].toString(),
        // users = (json["users"] as List).map((e) => e.toString()).toList(),
        seen = json["seen"].toString() == "true" ? true : false;
}

class GroupChatRoomModel {
  String chatId;
  String messageId;
  DateTime sentOn;
  String message;
  String messageType;
  GroupChatModel groupModel;

  bool seen;
  GroupChatRoomModel(
      {required this.chatId,
      required this.messageId,
      required this.sentOn,
      required this.message,
      required this.groupModel,
      required this.messageType,
      required this.seen});
  GroupChatRoomModel.fromJson({
    required Map<Object?, Object?> json,
    required this.messageId,
    required this.chatId,
    required this.groupModel,
  })  : sentOn = DateTime.parse(json["sentOn"].toString()),
        message = json["message"].toString(),
        messageType = json["messageType"].toString(),
        // users = (json["users"] as List).map((e) => e.toString()).toList(),
        seen = json["seen"].toString() == "true" ? true : false;
}
