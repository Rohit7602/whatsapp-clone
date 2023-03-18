// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import '../../database_event/event_listner.dart';
import '../../helper/base_getters.dart';
import '../../helper/global_function.dart';
import '../../main.dart';
import '../../tab_bar/tab_bar.dart';

createUser(
    BuildContext context,
    TextEditingController nameController,
    String phoneNumber,
    TextEditingController descriptionController,
    String downloadUrl,
    GetterSetterModel provider) async {
  try {
    print("Auth User Checker :::: ${auth.currentUser!.uid}");
    provider.loadingState(true);
    Map<String, dynamic> bodyData = {
      "Name": nameController.text,
      "Number": phoneNumber,
      "Description": descriptionController.text,
      "UserId": auth.currentUser!.uid,
      "ProfileImage": downloadUrl.isEmpty ? "" : downloadUrl,
      "CreatedOn": DateTime.now().toString(),
    };

    await database
        .ref("users/${auth.currentUser!.uid}")
        .set(bodyData)
        .then((value) async {
      sharedPrefs!.setBool("isLogin", true);
      // provider.removeChatRoom();
      DatabaseEventListner(context: context, provider: provider).getAllUsers();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Register Success")));
      AppServices.pushToAndRemove(context, HomeTabBar());
    }).then((value) {
      provider.loadingState(false);
    });
  } catch (e) {
    print(e.toString());
    provider.loadingState(false);
  }
}
