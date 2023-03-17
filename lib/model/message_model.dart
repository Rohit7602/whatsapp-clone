class MessageModel {
  String messageId;
  String message;
  String senderId;
  String recieverId;
  bool seen;
  List<String> users;
  DateTime sentOn;

  String messageType;

  MessageModel(this.messageId, this.message, this.senderId, this.recieverId,
      this.seen, this.messageType, this.users, this.sentOn);

  MessageModel.fromJson(Map<Object?, Object?> json, this.messageId)
      : message = json["message"].toString(),
        senderId = json["senderId"].toString(),
        recieverId = json["recieverId"].toString(),
        seen = json["seen"].toString() == "true" ? true : false,
        sentOn = DateTime.parse(json["sentOn"].toString()),
        messageType = json["messageType"].toString(),
        users = (json["users"] as List).map((e) => e.toString()).toList();
}
