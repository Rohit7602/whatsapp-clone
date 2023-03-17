// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/message_model.dart';
import '../getter_setter/getter_setter.dart';
import '../helper/global_function.dart';
import '../model/target_user_model.dart';
import '../model/user_model.dart';

class DatabaseEventListner {
  BuildContext context;
  GetterSetterModel provider;
  DatabaseEventListner({required this.context, required this.provider});

  getAllChatRooms() {
    database
        .ref("users/${auth.currentUser!.uid}/Mychatrooms/")
        .onChildAdded
        .listen((event) async {
      if (event.snapshot.exists) {
        var getChatrooms =
            event.snapshot.children.map((e) => e.value.toString());

        for (var chatId in getChatrooms) {
          var getChatroomsData =
              await database.ref("ChatRooms/$chatId/Chats/").get();
          var getUserList = await database.ref("users").get();

          var getLastMessage = getChatroomsData.children
              .map((e) => MessageModel.fromJson(
                  e.value as Map<Object?, Object?>, e.key.toString()))
              .toList()
              .last;

          var targetUser = getLastMessage.users
              .firstWhere((element) => element != auth.currentUser!.uid);

          var targetUserData = getUserList.children
              .firstWhere((e) => e.key.toString() == targetUser.toString());

          var getUserModel = UserModel.fromJson(
            targetUserData.value as Map<Object?, Object?>,
            targetUserData.key.toString(),
          );

          var getUserData = TargetUserModel.fromJson(
              chatRoomId: chatId,
              messageId: targetUserData.key.toString(),
              messageModel: getLastMessage,
              userModel: getUserModel);

          provider.getLastMesage(getUserData);
        }
      }
    });
  }

  getAllUsers() {
    database.ref("users").onValue.listen((event) {
      provider.emptyGetUserList();

      var getUserList = event.snapshot.children
          .where((element) => element.key.toString() != auth.currentUser!.uid)
          .toList();

      var data = getUserList
          .map((e) => UserModel.fromJson(
                e.value as Map<Object?, Object?>,
                e.key.toString(),
              ))
          .toList();

      provider.getUsers(data);

      var myData = event.snapshot.children
          .firstWhere((e) => e.key.toString() == auth.currentUser!.uid);
      var fetchMyData = UserModel.fromJson(
        myData.value as Map<Object?, Object?>,
        myData.key.toString(),
      );

      provider.getUserModel(fetchMyData);
    });
  }
}
