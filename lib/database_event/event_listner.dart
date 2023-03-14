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

  fetchChatRoomsEventListner() {
    if (provider.intializeChats) {
      database.ref("ChatRooms").onValue.listen((event) async {
        if (event.snapshot.exists) {
          var chatRooms = event.snapshot.children
              .where((element) =>
                  element.key.toString().contains(auth.currentUser!.uid))
              .toList();

          var chatRoomList = chatRooms.map((e) => e.key).toList();

          for (var room in chatRoomList) {
            var roomsList = chatRooms.map((v) => v.key!
                .split("_vs_")
                .firstWhere(
                    (element) => element.toString() != auth.currentUser!.uid));

            var userSnapshot =
                await database.ref("users/${roomsList.first}").get();
            var msgPath = await database.ref("ChatRooms/$room").get();
            var lastMessageGet = msgPath.children
                .map((e) => TargetUserModel.fromJson(
                    room.toString(),
                    MessageModel.fromJson(
                        e.value as Map<Object?, Object?>, e.key.toString()),
                    UserModel.fromJson(
                        userSnapshot.value as Map<Object?, Object?>,
                        userSnapshot.key.toString())))
                .toList()
                .last;

            provider.getLastMesage(lastMessageGet);
          }

          provider.intializeChatRoom(false);
        } else {
          provider.intializeChatRoom(false);
        }
      });
    }
  }

  getAllUsers() {
    database.ref("users").onValue.listen((event) {
      var data = event.snapshot.children
          .map((e) => UserModel.fromJson(
              e.value as Map<Object?, Object?>, e.key.toString()))
          .toList();

      provider.getUsers(data);
      var myData = event.snapshot.children
          .firstWhere((e) => e.key.toString() == auth.currentUser!.uid);

      var fetchMyData = UserModel.fromJson(
          myData.value as Map<Object?, Object?>, myData.key.toString());

      provider.getUserModel(fetchMyData);
    });
  }
}
