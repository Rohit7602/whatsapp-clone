import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/model/chatroom_model.dart';

import '../getter_setter/getter_setter.dart';

// List<ChatRoomModel> chatRoomModel = [];

final database = FirebaseDatabase.instance;
final auth = FirebaseAuth.instance;

class DatabaseEventListner {
  BuildContext context;
  GetterSetterModel provider;
  DatabaseEventListner({required this.context, required this.provider});
  databaseEvent(userId) {
    // var provider = Provider.of<GetterSetterModel>(context, listen: false);
    database.ref("ChatRooms/LastMessage/$userId/").onValue.listen(
      (event) {
        // chatRoomModel = event.snapshot.children
        //     .map((e) => ChatRoomModel.fromJson(
        //         e.value as Map<Object?, Object?>, e.key.toString()))
        //     .toList();

        // print("dat ::: $chatRoomModel");
        // provider.getLastMesage(dataSnapshot);
        // event.snapshot.children
        //     .map((e) => ChatRoomModel.fromJson(
        //         e.value as Map<Object?, Object?>, e.key.toString()))
        //     .toList();
      },
    );
  }
}
