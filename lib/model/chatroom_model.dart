import 'package:whatsapp_clone/model/user_model.dart';

class ChatRoomModel {
  String chatId;
  String messageId;
  DateTime sentOn;
  String message;
  String messageType;
  UserModel userModel;
  List<String> users;
  bool seen;
  ChatRoomModel(
      {required this.chatId,
      required this.messageId,
      required this.sentOn,
      required this.message,
      required this.userModel,
      required this.messageType,
      required this.users,
      required this.seen});
  ChatRoomModel.fromJson(
      {required Map<Object?, Object?> json,
      required this.messageId,
      required this.chatId,
      required this.userModel})
      : sentOn = DateTime.parse(json["sentOn"].toString()),
        message = json["message"].toString(),
        messageType = json["messageType"].toString(),
        users = (json["users"] as List).map((e) => e.toString()).toList(),
        seen = json["seen"].toString() == "true" ? true : false;
}
