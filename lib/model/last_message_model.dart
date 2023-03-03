class LastMessageModel {
  String messageId;
  String lastMessage;
  DateTime dateTime;
  String messageType;
  bool seen;

  LastMessageModel(this.messageId, this.lastMessage, this.dateTime,
      this.messageType, this.seen);

  LastMessageModel.fromJson(Map<Object?, Object?> json, this.messageId)
      : lastMessage = json["message"].toString(),
        dateTime = DateTime.parse(json["sentOn"].toString()),
        messageType = json["messageType"].toString(),
        seen = json["seen"].toString() == "true" ? true : false;
}
