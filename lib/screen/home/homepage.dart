// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/chat/chat_room.dart';
import 'package:whatsapp_clone/database/event_listner.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/model/chatroom_model.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';
import '../../styles/stylesheet.dart';
import '../../styles/textTheme.dart';
import '../contact/contact.dart';

dynamic lastMessage;

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final database = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;
  String roomList = "";

  List<ChatRoomModel> chatRoomModel = [];

  @override
  void initState() {
    getUser();
    findChatrooms();

    database.ref("ChatRooms/LastMessage/$roomList/").onValue.listen(
      (event) {
        var provider = Provider.of<GetterSetterModel>(context, listen: false);
        var modelList = event.snapshot.children
            .map((e) => ChatRoomModel.fromJson(
                e.value as Map<Object?, Object?>, e.key.toString()))
            .toList();

        if (mounted) {
          provider.getLastMesage(modelList);
          setState(() {
            chatRoomModel = modelList;
          });
        }

        print("dat ::: $chatRoomModel");
        // provider.getLastMesage(dataSnapshot);
        // event.snapshot.children
        //     .map((e) => ChatRoomModel.fromJson(
        //         e.value as Map<Object?, Object?>, e.key.toString()))
        //     .toList();
      },
    );

    super.initState();
  }

  getUser() async {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);
    var path = database.ref("users");
    var snapshot = await path.get();

    if (snapshot.exists) {
      var data = snapshot.children.map((element) => element.value).toList();
      provider.getUsers(data);
    }
  }

  findChatrooms() async {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);

    if (provider.intializeChats) {
      var snapshot = await database.ref("ChatRooms").get();

      if (snapshot.exists) {
        var chatRooms = snapshot.children
            .where((element) =>
                element.key.toString().contains(auth.currentUser!.uid))
            .toList();

        var roomsList = chatRooms
            .map((v) => v.key!.split("_vs_").firstWhere(
                (element) => element.toString() != auth.currentUser!.uid))
            .toList();

        for (var room in roomsList) {
          var userSnapshot = await database.ref("users/$room/").get();

          setState(() {
            roomList = room;
          });

          if (userSnapshot.exists) {
            provider.getMyChats(userSnapshot.value as Map<Object?, Object?>);
          }
          // var lastMessage =
          //     await database.ref("ChatRooms/LastMessage/$room/").get();

          // if (lastMessage.exists) {
          //   provider.getLastMesage(lastMessage.value as Map<Object?, Object?>);
          // }
        }
      }
      provider.intializeChatRoom(false);
    } else {
      provider.intializeChatRoom(false);
      null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 15),
        child: Consumer<GetterSetterModel>(
          builder: (context, data, chidl) {
            return Column(
              children: [
                ListView.separated(
                    separatorBuilder: (context, i) => sizedBox(15),
                    shrinkWrap: true,
                    itemCount: data.myChatRooms.length,
                    itemBuilder: (context, i) {
                      var dateTime = DateFormat('hh:mm a').format(
                          DateTime.parse(
                              data.lastMessage[i].sentOn.toString()));
                      var userData = data.getAllUser.firstWhere((element) =>
                          element["UserId"] == auth.currentUser!.uid);
                      return ListTile(
                        onTap: () {
                          pushTo(
                              context,
                              ChatRoomScreen(
                                  myData: userData,
                                  targetUser: data.getAllUser[i]));
                        },
                        title: Text(
                          data.myChatRooms[i]["Number"].toString(),
                        ),
                        subtitle: Text(
                          data.lastMessage[i].lastMessage.toString(),
                        ),
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: lightGreyColor),
                          child: const Icon(
                            Icons.person,
                            size: 35,
                            color: whiteColor,
                          ),
                        ),
                        trailing: Text(
                          dateTime,
                          style: TextThemeProvider.bodyTextSecondary
                              .copyWith(color: greyColor, fontSize: 12),
                        ),
                      );
                    }),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          // findChatrooms();
          pushTo(context, const ContactScreen());
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
  // findChatrooms() async {
  //   var provider = Provider.of<GetterSetterModel>(context, listen: false);
  //   if (provider.intializeChats) {
  //     var snapshot = await database.ref("ChatRooms").get();

  //     if (snapshot.exists) {
  //       var chatRooms = snapshot.children
  //           .where((element) =>
  //               element.key.toString().contains(auth.currentUser!.uid))
  //           .toList();

  //       var roomsList = chatRooms
  //           .map((v) => v.key!.split("_vs_").firstWhere(
  //               (element) => element.toString() != auth.currentUser!.uid))
  //           .toList();

  //       var lastMessage = await database.ref("ChatRooms/LastMessage").get();

  //       for (var room in roomsList) {
  //         var userSnapshot = await database.ref("users/$room/").get();

  //         if (userSnapshot.exists) {
  //           provider.getMyChats(userSnapshot.value as Map<Object?, Object?>);
  //         }
  //       }
  //     }
  //     provider.intializeChatRoom(false);
  //   } else {
  //     provider.intializeChatRoom(false);
  //     null;
  //   }
  // }