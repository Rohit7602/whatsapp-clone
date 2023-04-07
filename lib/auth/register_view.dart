// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/auth/components/send_otp.dart';
import 'package:whatsapp_clone/components/Loader/full_screen_loader.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import 'package:whatsapp_clone/widget/Custom_Image_Fun/custom_image_fun.dart';
import 'package:whatsapp_clone/widget/Custom_TextField/primary_textfield.dart';
import 'package:whatsapp_clone/widget/custom_button.dart';
import '../app_config.dart';
import '../helper/styles/app_style_sheet.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final numberController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  String otpCode = "";
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          SafeArea(
            child: Form(
              key: _key,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  CustomAssetImage(context, 250, AppImages.loginImage,
                      const EdgeInsets.symmetric(vertical: 30)),
                  Text("Let's Sign You in",
                      textAlign: TextAlign.center,
                      style: GetTextTheme.sf28_bold),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: Text(registerScreenDescription,
                        textAlign: TextAlign.center,
                        style: GetTextTheme.sf14_regular),
                  ),
                  const Text("Enter Your Phone Number"),
                  AppServices.addHeight(10),
                  PrimaryTextFieldView(
                    validator: phoneNumbeValidator(),
                    onChange: (v) {
                      setState(() {
                        numberController.text;
                      });
                      if (v.length == 10) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    hintText: "Enter Phone Number",
                    prefixIcon: Text(
                      "+91",
                      style: GetTextTheme.sf14_regular,
                    ),
                    controller: numberController,
                    fieldEmptyError: "Please Enter Text",
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${numberController.text.length}/10",
                          style: GetTextTheme.sf12_regular,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Carrier charges may apply.",
                        style: GetTextTheme.sf12_regular
                            .copyWith(color: AppColors.greyColor.shade400),
                      ),
                    ),
                  ),
                  CustomButton(
                    btnName: "Next",
                    onTap: () {
                      if (_key.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        sendOTP(context, numberController, otpCode);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          provider.isLoading ? const FullScreenLoader() : const SizedBox()
        ],
      ),
    );
  }
}
