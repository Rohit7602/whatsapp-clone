class ChatRoomModel {
  String chatId;
  DateTime sentOn;
  String lastMessage;

  ChatRoomModel(this.chatId, this.sentOn, this.lastMessage);

  ChatRoomModel.fromJson(Map<Object?, Object?> json, this.chatId)
      : sentOn = DateTime.parse(json["sentOn"].toString()),
        lastMessage = json["LastMessage"].toString();
}
