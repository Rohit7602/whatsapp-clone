import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import '../../helper/base_getters.dart';
import '../../helper/global_function.dart';
import '../verifyotp.dart';

// This function use in send to verification code in Mobile number.
sendOTP(BuildContext context, TextEditingController numberController,
    String otpCode) async {
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
              otpCode = codeSent;

              provider.loadingState(false);

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
