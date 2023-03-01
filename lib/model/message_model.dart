class MessageModel {
  String messageId;
  String message;
  String senderId;
  bool seen;
  DateTime sentOn;
  String users;

  MessageModel(this.messageId, this.message, this.senderId, this.seen,
      this.sentOn, this.users);

  MessageModel.fromJson(Map<Object?, Object?> json, this.messageId)
      : message = json["message"].toString(),
        senderId = json["senderId"].toString(),
        seen = json["seen"].toString() == "true" ? true : false,
        sentOn = DateTime.parse(json["sentOn"].toString()),
        users = json["users"].toString();
}
