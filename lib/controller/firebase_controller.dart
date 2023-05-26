// ignore_for_file: use_build_context_synchronously, avoid_print

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
import 'get_firebase_ref.dart';
import 'image_controller.dart';

String otpCode = "";

class FirebaseController {
  BuildContext context;
  GetterSetterModel provider;
  FirebaseController(this.context, this.provider);

  // This function use in send to verification code in Mobile number.
  Future sendOTP(BuildContext context, String numberController) async {
    try {
      provider.loadingState(true);
      await auth
          .verifyPhoneNumber(
              phoneNumber: "+91 $numberController",
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
                      phoneNumber: numberController.trim(), otpCode: otpCode),
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

      if (authUser.additionalUserInfo!.isNewUser) {
        createUser(context, phoneNumber);

        // Map<String, dynamic> bodyData = {
        //   "UserId": auth.currentUser!.uid,
        //   "CreatedOn": DateTime.now().toIso8601String(),
        // };
        // provider.profileForm.addAll(bodyData);

        // database
        //     .ref("users/${auth.currentUser!.uid}")
        //     .set(provider.profileForm);

        // sharedPrefs!.setBool("isLogin", true);

        // DatabaseEventListner(context: context, provider: provider)
        //     .getAllUsers();
        // DatabaseEventListner(context: context, provider: provider)
        //     .getAllChatRooms();
        // DatabaseEventListner(context: context, provider: provider)
        //     .getGroupChatRooms();

        // AppServices.pushToAndRemove(context, HomeTabBar());
        // provider.loadingState(false);
      }
    } catch (e) {
      print(e.toString());

      provider.loadingState(false);
    }
  }

  // function to create user Profile in Hex Chat
  Future createUser(
    BuildContext context,
    String phoneNumber,
  ) async {
    try {
      String downloadUrl = await ImageController.uploadImageOnDb(
          "profile_image", provider.profileForm["ProfileImage"]);

      if (downloadUrl.isNotEmpty) {
        Map<String, dynamic> bodyData = {
          "Name": provider.profileForm["Name"],
          "Number": phoneNumber,
          "Description": provider.profileForm["Description"],
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

          DatabaseEventListner(context: context, provider: provider)
              .getAllChatRooms();
          DatabaseEventListner(context: context, provider: provider)
              .getGroupChatRooms();

          ShowSnackbar(context: context, message: "Register Success").success();

          AppServices.pushToAndRemove(context, HomeTabBar());
        }).then((value) {
          provider.loadingState(false);
        });
      } else {
        ShowSnackbar(context: context, message: "Error").error();
        provider.loadingState(false);
      }
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

  // function to get user and navigate new screen
  getInitUser(String number) async {
    try {
      var getUser = await GetFirebaseRef.getInitUser(number).get();

      if (getUser.exists) {
        FirebaseController(context, provider).sendOTP(context, number);
      } else {
        AppServices.pushTo(
            context,
            UserProfileScreen(
              phoneNumber: number,
              otpCode: otpCode,
            ));
        provider.loadingState(false);
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      provider.loadingState(false);
    } catch (e) {
      print(e);
      provider.loadingState(false);
    }
  }
}
