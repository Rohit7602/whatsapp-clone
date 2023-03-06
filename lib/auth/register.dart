// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/auth/verifyotp.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/widget/custom_button.dart';
import 'package:whatsapp_clone/widget/custom_text_field.dart';
import '../styles/stylesheet.dart';
import '../styles/textTheme.dart';
import '../widget/custom_app_text.dart';
import '../widget/custom_image.dart';
import '../widget/custom_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final numberController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String otpCode = "";
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  getHeight(30),
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(registerImage),
                      ),
                    ),
                  ),
                  getHeight(20),
                  Text("Enter your phone number",
                      textAlign: TextAlign.center,
                      style: TextThemeProvider.heading1.copyWith(fontSize: 22)),
                  getHeight(10),
                  Text(
                    registerScreenDescription,
                    textAlign: TextAlign.center,
                    style: TextThemeProvider.bodyText
                        .copyWith(fontSize: 15, color: greyColor.shade400),
                  ),
                  getHeight(
                    40,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CustomTextFieldView(
                          hint: "+91",
                          readOnly: true,
                        ),
                      ),
                      getWidth(10),
                      Flexible(
                        flex: 4,
                        child: CustomTextFieldView(
                          hint: "Enter Phone Number",
                          numpad: true,
                          validator: (v) {
                            if (numberController.text.isEmpty) {
                              return "Please Enter Phone Number";
                            } else {
                              return null;
                            }
                          },
                          controller: numberController,
                          onChange: (value) {
                            if (value.length == 10) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  getHeight(10),
                  Text(
                    "Carrier charges may apply.",
                    style: TextThemeProvider.bodyTextSecondary
                        .copyWith(color: greyColor.shade400),
                  ),
                  getHeight(30),
                  provider.isLoading
                      ? showLoading()
                      : CustomButton(
                          btnName: "Next",
                          onTap: () {
                            if (_key.currentState!.validate()) {
                              createUser();

                              FocusScope.of(context).unfocus();
                            }
                          }),
                  getHeight(60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// This function use in send to verification code in Mobile number.

  createUser() async {
    var provider = Provider.of<GetterSetterModel>(context, listen: false);
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
                setState(() {
                  otpCode = codeSent;
                });
                provider.loadingState(false);

                pushTo(
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
}
