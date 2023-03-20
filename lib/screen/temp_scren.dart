// ignore_for_file: avoid_print, must_be_immutable

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import 'package:whatsapp_clone/helper/global_function.dart';
import 'package:whatsapp_clone/helper/styles/app_style_sheet.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/widget/custom_text_field.dart';

import '../getter_setter/getter_setter.dart';

class TemporaryScreen extends StatefulWidget {
  UserModel targetUser;
  String chatroomId;
  TemporaryScreen(
      {super.key, required this.chatroomId, required this.targetUser});

  @override
  State<TemporaryScreen> createState() => _TemporaryScreenState();
}

class _TemporaryScreenState extends State<TemporaryScreen> {
  final msgController = TextEditingController();
  getRoomId() {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);
    if (widget.chatroomId.isNotEmpty) {
      print("ifCase");
      return database.ref("ChatRooms/${widget.chatroomId}/Chats");
    } else {
      print("else Case");
      return database.ref("ChatRooms/${provider.getChatRoomId}/Chats");
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
    print(provider.getChatRoomId);
    return Scaffold(
      appBar: AppBar(title: const Text("Chatting screen")),
      body: SafeArea(
        child: Column(
          children: [
            widget.chatroomId.isEmpty
                ? Container(
                    height: 100,
                    width: 100,
                    color: AppColors.blueColor,
                  )
                : FirebaseAnimatedList(
                    shrinkWrap: true,
                    query: database.ref("ChatRooms/${widget.chatroomId}/Chats"),
                    itemBuilder: (context, snapshot, animation, i) {
                      final object = snapshot.value as Map<Object?, Object?>;
                      return Text(object['message'].toString());
                    },
                  ),
            AppServices.addHeight(30),
            provider.getChatRoomId == null
                ? Container(
                    height: 100,
                    width: 100,
                    color: Colors.amber,
                  )
                : FirebaseAnimatedList(
                    shrinkWrap: true,
                    query: database
                        .ref("ChatRooms/${provider.getChatRoomId}/Chats"),
                    itemBuilder: (context, snapshot, animation, i) {
                      final object = snapshot.value as Map<Object?, Object?>;
                      return Text(object['message'].toString());
                    },
                  ),
            AppServices.addHeight(50),
            CustomTextFieldView(
              controller: msgController,
              suffixIconEnable: true,
              suffixIcon: IconButton(
                  onPressed: () {
                    print("Provider id ${provider.getChatRoomId}");
                    print("Widget  id ${widget.chatroomId}");
                    sendMessaage();
                  },
                  icon: const Icon(Icons.send)),
            ),
          ],
        ),
      ),
    );
  }

  sendMessaage() async {
    Map<String, dynamic> bodyData = {
      "message": msgController.text,
      "senderId": auth.currentUser!.uid,
      "users": [auth.currentUser!.uid, widget.targetUser.userId]
    };

    var provider = Provider.of<GetterSetterModel>(context, listen: false);

    if (provider.getChatRoomId != null) {
      print("1st Case");
      await database
          .ref("ChatRooms/${provider.getChatRoomId}")
          .child("Chats/")
          .push()
          .set(bodyData);
    } else {
      if (widget.chatroomId.isNotEmpty) {
        print("2nd Case");
        await database
            .ref("ChatRooms/${widget.chatroomId}")
            .child("Chats/")
            .push()
            .set(bodyData);
      } else {
        print("3st Case");
        await database
            .ref("ChatRooms/")
            .push()
            .child("Chats/")
            .push()
            .set(bodyData)
            .then((value) async {
          var getChatRoom = await database.ref("ChatRooms/").get();

          var getMyChatRoomId =
              getChatRoom.children.map((e) => e.key.toString()).toList().last;
          setState(() {
            provider.updateChatRoomId(getMyChatRoomId);
          });
        });
      }
    }
  }
}
