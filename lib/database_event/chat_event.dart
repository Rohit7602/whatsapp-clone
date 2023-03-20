// ignore_for_file: avoid_print

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

  // getChatsList(String chatRoomId) async {
  //   provider.removeChatMessages();
  //   print("@nd List ");
  //   if (provider.messageModel.isEmpty) {
  //     if (chatRoomId.isNotEmpty) {
  //       print("@3rd List ");
  //       database
  //           .ref("ChatRooms/$chatRoomId/Chats/")
  //           .onChildChanged
  //           .listen((event) {
  //         var msgValue = MessageModel.fromJson(
  //             event.snapshot.value as Map<Object?, Object?>,
  //             event.snapshot.key.toString());

  //         provider.updateMessageModel(msgValue);
  //       });
  //     }
  //   }
  // }

  isSeenMessages(chatRoomId, targetUserId) {
    print(chatRoomId);
    database.ref("ChatRooms/$chatRoomId/Chats").onChildChanged.listen(
      (event) async {
        print(event.snapshot.key.toString());
        if (event.snapshot.exists) {
          print("Event Snapshot :::: ${event.snapshot.value}");
          // var msgKey = event.snapshot.children.map((e) => e.key);

          // var eventKey = event.snapshot.children.map((e) => e.key).last;

          // var eventValue = event.snapshot.children.map((e) => e.value).last;

          // var msgModel = MessageModel.fromJson(
          //     eventValue as Map<Object?, Object?>, eventKey.toString());

          // if (msgModel.senderId == targetUserId) {
          //   for (var elements in msgKey) {
          //     database.ref("ChatRooms/$chatRoomId/Chats/$elements/").update({
          //       "seen": true,
          //     });

          //     // var msgIndex = provider.messageModel
          //     //     .indexWhere((element) => element.messageId == elements);

          //     // print("Message Index Checker $msgIndex ");

          //     provider.updateMessageStatus(elements!, true, provider);
          //   }
          // }
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
