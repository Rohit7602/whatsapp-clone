// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/components/snackbars/valt_snackbar.dart';

import 'package:whatsapp_clone/getter_setter/getter_setter.dart';

import '../auth/user_profile_view.dart';
import '../auth/verifyotp_view.dart';
import '../database_event/event_listner.dart';
import '../helper/base_getters.dart';
import '../helper/global_function.dart';
import '../main.dart';
import '../tab_bar/tab_bar.dart';

class FirebaseController {
  BuildContext context;
  GetterSetterModel provider;
  FirebaseController(this.context, this.provider);

  // This function use in send to verification code in Mobile number.
  Future sendOTP(BuildContext context, TextEditingController numberController,
      String otpCode) async {
    try {
      provider.loadingState(true);
      await auth
          .verifyPhoneNumber(
              phoneNumber: "+91 ${numberController.text}",
              verificationCompleted: (verificationCompleted) {
                provider.loadingState(false);
              },
              verificationFailed: (verificationFailed) {
                provider.loadingState(false);
              },
              codeSent: (codeSent, i) {
                otpCode = codeSent;

                AppServices.pushTo(
                  context,
                  VerifyOTP(
                      phoneNumber: numberController.text.trim(),
                      otpCode: otpCode),
                );

                provider.loadingState(false);
              },
              codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout) {})
          .then((value) {});
    } catch (e) {
      print(e.toString());
      provider.loadingState(false);
    }
  }

  // function to verify your number with otp
  Future verifyOtp(
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
          AppServices.pushToAndRemove(context, HomeTabBar());
          provider.loadingState(false);
        } else {
          AppServices.pushToAndRemove(
              context, UserProfileScreen(phoneNumber: phoneNumber));
          provider.loadingState(false);
        }
      }
    } catch (e) {
      print(e.toString());

      provider.loadingState(false);
    }
  }

  // function to create user Profile in Hex Chat
  Future createUser(
    BuildContext context,
    TextEditingController nameController,
    String phoneNumber,
    TextEditingController descriptionController,
    String downloadUrl,
  ) async {
    try {
      provider.loadingState(true);
      Map<String, dynamic> bodyData = {
        "Name": nameController.text,
        "Number": phoneNumber,
        "Description": descriptionController.text,
        "UserId": auth.currentUser!.uid,
        "ProfileImage": downloadUrl.isEmpty ? "" : downloadUrl,
        "CreatedOn": DateTime.now().toIso8601String(),
      };

      await database
          .ref("users/${auth.currentUser!.uid}")
          .set(bodyData)
          .then((value) async {
        sharedPrefs!.setBool("isLogin", true);
        // provider.removeChatRoom();
        DatabaseEventListner(context: context, provider: provider)
            .getAllUsers();

        ShowSnackbar(context: context, message: "Register Success").success();

        AppServices.pushToAndRemove(context, HomeTabBar());
      }).then((value) {
        provider.loadingState(false);
      });
    } catch (e) {
      print(e.toString());
      provider.loadingState(false);
    }
  }

  // function to check chat room available or not
  static Future<String> isChatRoomAvailable(String targetUser) async {
    var myChatRoomList =
        await database.ref("users/${auth.currentUser!.uid}/Mychatrooms/").get();
    var myChatID = myChatRoomList.children;
    if (myChatID.isNotEmpty) {
      var userChatID = myChatID.map((e) => e.key).toList();
      var targetChatRoomList =
          await database.ref("users/$targetUser/Mychatrooms/").get();

      var targetChatID =
          targetChatRoomList.children.map((e) => e.key.toString()).toList();

      for (var myroom in userChatID) {
        for (var targetroom in targetChatID) {
          if (myroom == targetroom) {
            return myroom!;
          } else {
            continue;
          }
        }
      }
    } else {
      return "";
    }
    return "";
  }

  // function to set user Status
  static void setUserStatus(BuildContext context, String status) async {
    database.ref("users/${auth.currentUser!.uid}").update({
      "Status": status,
    });
  }
}
