import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';

import '../helper/global_function.dart';
import '../model/message_model.dart';
import '../widget/create_chatroom.dart';

class ChatEventListner {
  BuildContext context;
  GetterSetterModel provider;
  ChatEventListner({required this.context, required this.provider});

  getMessageList(targetUser) {
    database
        .ref("ChatRooms/${createChatRoomId(auth.currentUser!.uid, targetUser)}")
        .onValue
        .listen((event) {
      var msg = event.snapshot.children
          .map((e) => MessageModel.fromJson(
              e.value as Map<Object?, Object?>, e.key.toString()))
          .toList();

      provider.updateMessageModel(msg);

      database
          .ref(
              "ChatRooms/${createChatRoomId(auth.currentUser!.uid, targetUser)}")
          .onValue
          .listen(
        (event) async {
          var eventKey = event.snapshot.children.map((e) => e.key).toList();
          for (var element in eventKey) {
            var recieverId = await database
                .ref(
                    "ChatRooms/${createChatRoomId(auth.currentUser!.uid, targetUser)}/$element/senderId")
                .get();

            if (recieverId.value.toString() != auth.currentUser!.uid) {
              database
                  .ref(
                      "ChatRooms/${createChatRoomId(auth.currentUser!.uid, targetUser)}/$element/")
                  .update({
                "seen": true,
              });
            }
          }
        },
      );

      database.ref("users/$targetUser").onValue.listen((event) {
        var eventSnapshot = event.snapshot.children.map((e) => e).toList();
        var getStatus =
            eventSnapshot.firstWhere((element) => element.key == "Status");
        var provider = Provider.of<GetterSetterModel>(context, listen: false);
        provider.getStatus(getStatus.value.toString());
      });
    });
  }
}
