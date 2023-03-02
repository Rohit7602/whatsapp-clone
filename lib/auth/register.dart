import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/auth/verifyotp.dart';
import 'package:whatsapp_clone/widget/custom_button.dart';
import 'package:whatsapp_clone/widget/custom_text_field.dart';
import '../styles/stylesheet.dart';
import '../styles/textTheme.dart';
import '../widget/custom_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final numberController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isLoading = false;
  String otpCode = "";
  @override
  Widget build(BuildContext context) {
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
                  sizedBox(30),
                  Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("asset/register/register.png")))),
                  sizedBox(20),
                  Text("Enter your phone number",
                      textAlign: TextAlign.center,
                      style: TextThemeProvider.heading1.copyWith(fontSize: 22)),
                  sizedBox(10),
                  Text(
                    "Whatsapp will need to verify your phone number.",
                    textAlign: TextAlign.center,
                    style: TextThemeProvider.bodyText
                        .copyWith(fontSize: 15, color: greyColor.shade400),
                  ),
                  const SizedBox(
                    height: 40,
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
                      const SizedBox(
                        width: 10,
                      ),
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
                  sizedBox(10),
                  Text(
                    "Carrier charges may apply.",
                    style: TextThemeProvider.bodyTextSecondary
                        .copyWith(color: greyColor.shade400),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  isLoading
                      ? showLoading()
                      : CustomButton(
                          btnName: "Next",
                          onTap: () {
                            if (_key.currentState!.validate()) {
                              createUser();

                              FocusScope.of(context).unfocus();
                            }
                          }),
                  const SizedBox(
                    height: 60,
                  ),
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
    try {
      setState(() {
        isLoading = true;
      });

      await auth.verifyPhoneNumber(
          phoneNumber: "+91 ${numberController.text}",
          verificationCompleted: (verificationCompleted) {
            setState(() {
              isLoading = false;
            });
          },
          verificationFailed: (verificationFailed) {
            setState(() {
              isLoading = false;
            });
          },
          codeSent: (codeSent, i) {
            setState(() {
              otpCode = codeSent;
              setState(() {
                isLoading = false;
              });
            });

            pushTo(
              context,
              VerifyOTP(
                  phoneNumber: numberController.text.trim(), otpCode: otpCode),
            );

            setState(() {
              isLoading = false;
            });
          },
          codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout) {});
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
