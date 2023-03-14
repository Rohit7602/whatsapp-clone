// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/components/chat_room_list.dart';
import 'package:whatsapp_clone/database_event/event_listner.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/screen/setting/profile_screen.dart';
import 'package:whatsapp_clone/widget/Custom_Image_Fun/custom_image_fun.dart';
import '../../helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';
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
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        margin: EdgeInsets.only(top: 15.h),
        child: Consumer<GetterSetterModel>(
          builder: (context, data, chidl) {
            return data.targetUserModel.isEmpty
                ? CustomAssetImage(context, 300, AppImages.startChat,
                    EdgeInsets.only(top: 60.h))
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
        return data.targetUserModel.isEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    AppImages.chatGIF,
                    height: 70.h,
                  ),
                  Image.asset(
                    AppImages.arrowGIF,
                    height: 60.h,
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
                  AppServices.pushTo(context, const ProfileScreen());
                },
                child: const Icon(Icons.person),
              );
      },
    );
  }
}
