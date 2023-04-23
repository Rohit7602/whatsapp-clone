// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../getter_setter/getter_setter.dart';
import '../helper/global_function.dart';
import '../model/chatroom_model.dart';
import '../model/group_model.dart';
import '../model/user_model.dart';

class DatabaseEventListner {
  BuildContext context;
  GetterSetterModel provider;
  DatabaseEventListner({required this.context, required this.provider});

  getAllChatRooms() {
    provider.removeChatRoom();
    database
        .ref("users/${auth.currentUser!.uid}/Mychatrooms/Individual/")
        .onChildAdded
        .listen(
      (event) async {
        if (event.snapshot.exists) {
          // provider.removeLastMessage();
          var getChatrooms =
              event.snapshot.children.map((e) => e.value.toString());

          for (var chatId in getChatrooms) {
            var getMembersList =
                await database.ref("ChatRooms/$chatId/Members/users").get();
            var getChatRooms =
                await database.ref("ChatRooms/$chatId/Chats/").get();
            var getUserList = await database.ref("users").get();

            print(getMembersList.children.map((e) => e.value));

            if (getMembersList.children.isNotEmpty) {
              var targetUser = getMembersList.children.firstWhere((element) =>
                  element.value.toString() != auth.currentUser!.uid);

              var targetUserData = getUserList.children.firstWhere(
                  (e) => e.key.toString() == targetUser.value.toString());

              var getUserModel = UserModel.fromJson(
                targetUserData.value as Map<Object?, Object?>,
                targetUserData.key.toString(),
              );

              var getMember =
                  getMembersList.children.map((e) => e.value).toList();

              var getUserData = getChatRooms.children
                  .map((e) => ChatRoomModel.fromJson(
                      json: e.value as Map<Object?, Object?>,
                      messageId: e.key.toString(),
                      chatId: chatId,
                      userModel: getUserModel,
                      users: [getMember]))
                  .last;

              provider.updateChatRoomModel(getUserData);
            }
          }
        }
      },
    );
  }

  getGroupChatRooms() {
    database
        .ref("users/${auth.currentUser!.uid}/Mychatrooms/Group/")
        .onChildAdded
        .listen(
      (event) async {
        if (event.snapshot.exists) {
          // provider.removeLastMessage();
          var getChatrooms =
              event.snapshot.children.map((e) => e.value.toString());

          for (var chatId in getChatrooms) {
            var getMemberList =
                await database.ref("ChatRooms/$chatId/Members/").get();
            var getUserList =
                await database.ref("ChatRooms/$chatId/Members/users").get();
            var getChatRooms =
                await database.ref("ChatRooms/$chatId/Chats/").get();

            if (getUserList.children.isNotEmpty) {
              var currentUserData = getUserList.children.firstWhere((element) =>
                  element.value.toString() == auth.currentUser!.uid);

              if (currentUserData.exists) {
                var getGroupModel = GroupChatModel.fromJson(
                    getMemberList.value as Map<Object?, Object?>,
                    chatId.toString());

                var getUserData = getChatRooms.children
                    .map((e) => ChatRoomModel.fromJson(
                          json: e.value as Map<Object?, Object?>,
                          messageId: e.key.toString(),
                          chatId: chatId,
                          groupModel: getGroupModel,
                        ))
                    .last;

                provider.updateChatRoomModel(getUserData);
              }
            }
          }
        }
      },
    );
  }

  // function to get all available users in Hexchat
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
        .where((element) => element!.userId == event.snapshot.key.toString())
        .toList();
    if (isUpdatable.isEmpty) return;
    final roomIndex = provider.chatRoomModel
        .indexWhere((element) => element.userModel == isUpdatable.first);

    provider.updateUserStatus(
        (event.snapshot.value as Map<Object?, Object?>)['Status'].toString(),
        roomIndex);
  }
}
