// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/widget/Custom_Image_Fun/custom_image_fun.dart';
import '../app_config.dart';
import '../components/Loader/button_loader.dart';
import 'components/verify_otp_fun.dart';
import '../helper/base_getters.dart';
import '../helper/styles/app_style_sheet.dart';

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

  Timer? timer;
  int resendOtpTime = 30;

  void startTimer() {
    var updateTime = const Duration(seconds: 1);

    timer = Timer.periodic(updateTime, (timer) {
      if (resendOtpTime == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          resendOtpTime--;
        });
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
    const focusedBorderColor = AppColors.primaryColor;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = AppColors.primaryColor;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle:
          GetTextTheme.sf22_regular.copyWith(color: AppColors.primaryColor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  CustomAssetImage(context, 250, AppImages.otpGif,
                      const EdgeInsets.only(top: 20, bottom: 30)),
                  Text("Enter Your OTP!!",
                      textAlign: TextAlign.center,
                      style: GetTextTheme.sf28_bold),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Text(
                        "$verifyOTPDescription ${widget.phoneNumber} recently.",
                        textAlign: TextAlign.center,
                        style: GetTextTheme.sf12_regular),
                  ),
                  Text("Request a call or wait before requesting an SMS.",
                      textAlign: TextAlign.center,
                      style: GetTextTheme.sf14_regular
                          .copyWith(color: AppColors.greyColor.shade500)),
                  AppServices.addHeight(20),
                  PinFieldView(defaultPinTheme, context, provider,
                      focusedBorderColor, fillColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: resendOtpTime != 0
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.spaceBetween,
                      children: [
                        resendOtpTime != 0
                            ? const SizedBox()
                            : TextButton(
                                onPressed: () {},
                                child: const Text("Resend OTP")),
                        Text("0:$resendOtpTime min")
                      ],
                    ),
                  ),
                  provider.isLoading ? const ButtonLoader() : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Pinput PinFieldView(PinTheme defaultPinTheme, BuildContext context,
      GetterSetterModel provider, Color focusedBorderColor, Color fillColor) {
    return Pinput(
      length: 6,
      autofocus: true,
      controller: pinController,
      focusNode: focusNode,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
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
            verifyOtp(context, widget.otpCode, pinController,
                widget.phoneNumber, provider);
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
        border: Border.all(color: AppColors.redColor),
      ),
    );
  }
}
