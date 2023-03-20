// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/message_model.dart';
import '../getter_setter/getter_setter.dart';
import '../helper/global_function.dart';
import '../model/chatroom_model.dart';
import '../model/user_model.dart';

class DatabaseEventListner {
  BuildContext context;
  GetterSetterModel provider;
  DatabaseEventListner({required this.context, required this.provider});

  getAllChatRooms() {
    provider.removeChatRoom();
    database
        .ref("users/${auth.currentUser!.uid}/Mychatrooms/")
        .onChildAdded
        .listen(
      (event) async {
        if (event.snapshot.exists) {
          // provider.removeLastMessage();
          var getChatrooms =
              event.snapshot.children.map((e) => e.value.toString());

          for (var chatId in getChatrooms) {
            var getChatroomsData =
                await database.ref("ChatRooms/$chatId/Chats/").get();
            var getUserList = await database.ref("users").get();

            if (getChatroomsData.children.isNotEmpty) {
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

              var getUserData = getChatroomsData.children
                  .map((e) => ChatRoomModel.fromJson(
                      json: e.value as Map<Object?, Object?>,
                      messageId: e.key.toString(),
                      chatId: chatId,
                      userModel: getUserModel))
                  .last;

              provider.updateChatRoomModel(getUserData);
            }
          }
        }
      },
    );
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

  updateUserStatus(DatabaseEvent event) {
    final userList = provider.chatRoomModel.map((e) => e.userModel).toList();
    var isUpdatable = userList
        .where((element) => element.userId == event.snapshot.key.toString())
        .toList();
    if (isUpdatable.isEmpty) return;
    final roomIndex = provider.chatRoomModel
        .indexWhere((element) => element.userModel == isUpdatable.first);

    provider.updateUserStatus(
        (event.snapshot.value as Map<Object?, Object?>)['Status'].toString(),
        roomIndex);
  }
}
