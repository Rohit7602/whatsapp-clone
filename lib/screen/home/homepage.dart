// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/components/chat_room_list.dart';
import 'package:whatsapp_clone/database_event/event_listner.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/screen/setting/profile_screen.dart';
import 'package:whatsapp_clone/widget/custom_image.dart';
import 'package:whatsapp_clone/widget/custom_widget.dart';
import '../../styles/stylesheet.dart';
import '../contact/contact.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);

    DatabaseEventListner(context: context, provider: provider).getAllUsers();
    DatabaseEventListner(context: context, provider: provider)
        .fetchChatRoomsEventListner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 15),
        child: Consumer<GetterSetterModel>(
          builder: (context, data, chidl) {
            return data.targetUserModel.isEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 40),
                    alignment: Alignment.center,
                    height: 300,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(startChat),
                    )),
                  )
                : const ChatRoomList();
          },
        ),
      ),
      floatingActionButton: Consumer<GetterSetterModel>(
        builder: (context, data, child) {
          return data.targetUserModel.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      chatGIF,
                      height: 70,
                    ),
                    Image.asset(
                      arrowGIF,
                      height: 60,
                    ),
                    FloatingActionButton(
                      backgroundColor: primaryColor,
                      onPressed: () async {
                        pushTo(context, const ContactScreen());
                      },
                      child: const Icon(Icons.chat),
                    ),
                  ],
                )
              : FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () async {
                    pushTo(context, const ProfileScreen());
                  },
                  child: const Icon(Icons.person),
                );
        },
      ),
    );
  }
}
