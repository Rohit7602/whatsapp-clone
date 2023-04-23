// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/styles/app_style_sheet.dart';

final auth = FirebaseAuth.instance;

class CustomButton extends StatelessWidget {
  String btnName;
  Color btnColor;
  Function onTap;

  CustomButton(
      {required this.btnName,
      this.btnColor = AppColors.primaryColor,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width - 100, 45)),
              backgroundColor: MaterialStateProperty.all(btnColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ))),
          onPressed: () => onTap(),
          child: Text(
            btnName,
            style: const TextStyle(color: AppColors.whiteColor),
          ),
        ),
      ],
    );
  }
}
