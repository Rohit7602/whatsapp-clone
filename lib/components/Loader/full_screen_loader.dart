import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import 'package:whatsapp_clone/helper/styles/app_style_sheet.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: AppServices.getScreenHeight(context),
      width: AppServices.getScreenWidth(context),
      decoration: BoxDecoration(color: AppColors.blackColor.withOpacity(0.3)),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.whiteColor),
        child: const SpinKitCircle(
          color: Colors.red,
          size: 45.0,
        ),
      ),
    );
  }
}
