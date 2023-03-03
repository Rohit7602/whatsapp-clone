import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';

final auth = FirebaseAuth.instance;

class CustomButton extends StatelessWidget {
  String btnName;
  Color btnColor;
  Function onTap;

  CustomButton(
      {required this.btnName,
      this.btnColor = primaryColor,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
        style: const TextStyle(color: whiteColor),
      ),
    );
  }
}
