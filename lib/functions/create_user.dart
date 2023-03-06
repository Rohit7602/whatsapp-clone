// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import '../main.dart';
import '../tab_bar/tab_bar.dart';
import '../widget/custom_instance.dart';
import '../widget/custom_widget.dart';

createUser(
    BuildContext context,
    TextEditingController nameController,
    String phoneNumber,
    TextEditingController descriptionController,
    String downloadUrl,
    GetterSetterModel provider) async {
  try {
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Register Success")));
      pushToAndRemove(
          context,
          HomeTabBar(
            currentIndex: 1,
          ));
    }).then((value) {
      provider.loadingState(false);
    });
  } catch (e) {
    print(e.toString());
    provider.loadingState(false);
  }
}
