import 'package:flutter/material.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import '../helper/global_function.dart';
import '../model/message_model.dart';

class ChatEventListner {
  BuildContext context;
  GetterSetterModel provider;

  ChatEventListner({required this.context, required this.provider});

  getChatsMessageList(String chatRoomId) async {
    provider.removeChatMessages();
    if (provider.messageModel.isEmpty) {
      if (chatRoomId.isNotEmpty) {
        database
            .ref("ChatRooms/$chatRoomId/Chats")
            .onChildAdded
            .listen((event) {
          var msgValue = MessageModel.fromJson(
              event.snapshot.value as Map<Object?, Object?>,
              event.snapshot.key.toString());

          provider.updateMessageModel(msgValue);
        });
      }
    }
  }

  isSeenMessages(chatRoomId, targetUserId) {
    database.ref("ChatRooms/$chatRoomId/Chats").onValue.listen(
      (event) async {
        if (event.snapshot.exists) {
          var eventData = event.snapshot.children.map((e) => e.key);
          var eventKey = event.snapshot.children.map((e) => e.key).last;

          var eventValue = event.snapshot.children.map((e) => e.value).last;

          var msgModel = MessageModel.fromJson(
              eventValue as Map<Object?, Object?>, eventKey.toString());

          print("sernder Id");
          print(msgModel.senderId);
          print("targetUser Id");
          print(targetUserId);

          if (msgModel.senderId == targetUserId) {
            for (var element in eventData) {
              database.ref("ChatRooms/$chatRoomId/Chats/$element/").update({
                "seen": true,
              });
            }
          }
        } else {
          print("Event Data Not Exist");
        }
      },
    );
  }

  getLastMessage() {
    database.ref("ChatRooms").onChildChanged.listen((event) async {
      if (event.snapshot.exists) {
        var rooomId = event.snapshot.key.toString();
        bool roomAvailable =
            provider.chatRoomModel.any((element) => element.chatId == rooomId);
        if (roomAvailable) {
          var chatsSnapshot =
              await database.ref("ChatRooms/$rooomId/Chats").get();
          var lastMsgSnapshot =
              chatsSnapshot.children.last.value as Map<Object?, Object?>;
          provider.updateLastMsg(
              rooomId,
              lastMsgSnapshot['message'].toString(),
              lastMsgSnapshot['seen'].toString() == "true" ? true : false,
              lastMsgSnapshot['messageType'].toString(),
              lastMsgSnapshot['sentOn'].toString());
        } else {
          null;
        }
      }
    });
  }
}
