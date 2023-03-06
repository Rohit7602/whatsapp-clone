// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import '../auth/user_profile.dart';
import '../main.dart';
import '../tab_bar/tab_bar.dart';
import '../widget/custom_instance.dart';
import '../widget/custom_widget.dart';

verifyOtp(
    BuildContext context,
    String otpCode,
    TextEditingController pinController,
    String phoneNumber,
    GetterSetterModel provider) async {
  try {
    provider.loadingState(true);

    var credential = PhoneAuthProvider.credential(
        verificationId: otpCode, smsCode: pinController.text);

    var authUser = await auth.signInWithCredential(credential);

    if (authUser.user!.phoneNumber!.isNotEmpty) {
      var userPath = await database.ref("users").get();
      var getUserKey = userPath.children
          .any((element) => element.key.toString() == auth.currentUser!.uid);

      if (getUserKey == true) {
        sharedPrefs!.setBool("isLogin", true);
        pushTo(context, HomeTabBar(currentIndex: 1));
        provider.loadingState(false);
      } else {
        pushTo(context, UserProfileScreen(phoneNumber: phoneNumber));
        provider.loadingState(false);
      }
    }
  } catch (e) {
    print(e.toString());

    provider.loadingState(false);
  }
}
