// ignore_for_file: use_build_context_synchronously, must_be_immutable, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:whatsapp_clone/auth/user_profile.dart';
import 'package:whatsapp_clone/database/event_listner.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/styles/textTheme.dart';
import 'package:whatsapp_clone/tab_bar/tab_bar.dart';
import '../styles/stylesheet.dart';
import '../widget/custom_widget.dart';

class VerifyOTP extends StatefulWidget {
  String phoneNumber;
  String otpCode;

  VerifyOTP({super.key, required this.phoneNumber, required this.otpCode});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final nameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextThemeProvider.heading1
          .copyWith(fontSize: 22, color: lightGreenColor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "asset/register/verify_otp.jpg")))),
                  sizedBox(20),
                  Text("Verifying your number",
                      textAlign: TextAlign.center,
                      style: TextThemeProvider.heading1
                          .copyWith(fontSize: 22, color: blackColor)),
                  sizedBox(30),
                  Text(
                      "Can't send and SMS with your code because you've tried to register +91 ${widget.phoneNumber} recently.",
                      textAlign: TextAlign.center,
                      style: TextThemeProvider.bodyText
                          .copyWith(color: greyColor.shade400, fontSize: 15)),
                  sizedBox(5),
                  Text("Request a call or wait before requesting an SMS.",
                      textAlign: TextAlign.center,
                      style: TextThemeProvider.bodyText
                          .copyWith(color: greyColor.shade400, fontSize: 15)),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Wrong Number?",
                        style: TextThemeProvider.bodyTextSmall
                            .copyWith(color: primaryColor),
                      )),
                  sizedBox(20),
                  Pinput(
                    length: 6,
                    autofocus: true,
                    controller: pinController,
                    focusNode: focusNode,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Please Enter Your OTP";
                      } else {
                        return null;
                      }
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (value) {
                      if (value.length == 6) {
                        FocusScope.of(context).unfocus();
                        if (_key.currentState!.validate()) {
                          verifyOtp();
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                  sizedBox(15),
                  Text(
                    "Enter 6 Digit OTP",
                    style: TextThemeProvider.bodyTextSmall
                        .copyWith(color: greyColor),
                  ),
                  sizedBox(15),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: lightGreenColor,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  verifyOtp() async {
    try {
      setState(() {
        isLoading = true;
      });
      var credential = PhoneAuthProvider.credential(
          verificationId: widget.otpCode, smsCode: pinController.text);

      var authUser = await auth.signInWithCredential(credential);

      if (authUser.user!.phoneNumber!.isNotEmpty) {
        var userPath = await database.ref("users").get();
        var getUserKey = userPath.children
            .any((element) => element.key.toString() == auth.currentUser!.uid);

        if (getUserKey == true) {
          sharedPrefs!.setBool("isLogin", true);
          pushTo(context, HomeTabBar(currentIndex: 1));
        } else {
          pushTo(context, UserProfileScreen(phoneNumber: widget.phoneNumber));
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print(e.toString());

      setState(() {
        isLoading = false;
        pinController.clear();
      });
    }
  }
}
