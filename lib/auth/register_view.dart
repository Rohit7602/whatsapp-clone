// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/auth/components/send_otp.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/widget/Custom_Image_Fun/custom_image_fun.dart';
import 'package:whatsapp_clone/widget/Custom_TextField/primary_textfield.dart';
import 'package:whatsapp_clone/widget/custom_button.dart';
import '../app_config.dart';
import '../components/show_loading.dart';
import '../helper/styles/app_style_sheet.dart';

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
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Form(
          key: _key,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            children: [
              CustomAssetImage(context, 250, AppImages.registerImage,
                  EdgeInsets.symmetric(vertical: 30.h)),
              Text("Let's Sign You in",
                  textAlign: TextAlign.center, style: GetTextTheme.sf28_bold),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 40.h),
                child: Text(registerScreenDescription,
                    textAlign: TextAlign.center,
                    style: GetTextTheme.sf14_regular),
              ),
              PrimaryTextFieldView(
                validator: phoneNumbeValidator(),
                onChange: (v) {
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
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Carrier charges may apply.",
                    style: GetTextTheme.sf12_regular
                        .copyWith(color: AppColors.greyColor.shade400),
                  ),
                ),
              ),
              provider.isLoading
                  ? showLoading()
                  : CustomButton(
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
    );
  }
}
