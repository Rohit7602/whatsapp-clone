// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/widget/Custom_Image_Fun/custom_image_fun.dart';
import '../../database_event/chat_event.dart';
import '../../helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';
import '../contact/contact.dart';
import 'chat_room_list.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  void initState() {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);
    ChatEventListner(context: context, provider: provider).getLastMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Consumer<GetterSetterModel>(
          builder: (context, data, chidl) {
            return data.chatRoomModel.isEmpty
                ? CustomAssetImage(context, 300, AppImages.startChat,
                    const EdgeInsets.only(top: 60))
                : const ChatRoomList();
          },
        ),
      ),
      floatingActionButton: FloatingIconView(),
    );
  }

  Consumer<GetterSetterModel> FloatingIconView() {
    return Consumer<GetterSetterModel>(
      builder: (context, data, child) {
        return data.chatRoomModel.isEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    AppImages.chatGIF,
                    height: 70,
                  ),
                  Image.asset(
                    AppImages.arrowGIF,
                    height: 60,
                  ),
                  FloatingActionButton(
                    backgroundColor: AppColors.primaryColor,
                    onPressed: () async {
                      AppServices.pushTo(context, const ContactScreen());
                    },
                    child: const Icon(Icons.chat),
                  ),
                ],
              )
            : FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                onPressed: () async {
                  // AppServices.pushTo(context, const ProfileScreen());
                  AppServices.pushTo(context, const ContactScreen());
                },
                child: const Icon(Icons.person),
              );
      },
    );
  }
}
