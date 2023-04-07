class MessageModel {
  String groupId;
  String messageId;
  String message;
  String senderId;

  // msgState status;
  bool seen;
  List<String> users;
  DateTime sentOn;

  String messageType;

  MessageModel(
    this.groupId,
    this.messageId,
    this.message,
    this.senderId,
    this.seen,
    this.messageType,
    this.users,
    this.sentOn,
  );

  MessageModel.fromJson(Map<Object?, Object?> json, this.messageId)
      : groupId = json["groupId"] != null ? json["groupId"].toString() : "",
        message = json["message"].toString(),
        senderId = json["senderId"].toString(),
        seen = json["seen"].toString() == "true" ? true : false,
        sentOn = DateTime.parse(json["sentOn"].toString()),
        messageType = json["messageType"].toString(),
        // status = msgState.values.firstWhere(
        //     (element) => element.name == json['msgStatus'].toString()),
        users = json["users"] != null
            ? (json["users"] as List).map((e) => e.toString()).toList()
            : [];
}
