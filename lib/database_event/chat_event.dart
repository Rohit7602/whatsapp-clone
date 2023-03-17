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
          // var msgValue = event.snapshot.children
          //     .map((e) => MessageModel.fromJson(
          //         event.snapshot.value as Map<Object?, Object?>,
          //         event.snapshot.key.toString()))
          //     .toList();

          var msgValue = MessageModel.fromJson(
              event.snapshot.value as Map<Object?, Object?>,
              event.snapshot.key.toString());

          provider.updateMessageModel(msgValue);
        });
      }
    }
  }

  isSeenMessages(chatRoomId, targetUserId) {
    database.ref("ChatRooms/$chatRoomId/").onChildAdded.listen(
      (event) async {
        if (targetUserId != null) {
          var eventKey = event.snapshot.children.map((e) => e.value).last;

          // for (var element in eventKey) {
          //   database.ref("ChatRooms/$chatRoomId/Chats/$element").update({
          //     "seen": true,
          //   });
          // }
        } else {
          print("elseCase:::::::");
        }
      },
    );
  }
}
