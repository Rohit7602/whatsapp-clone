import 'package:flutter/material.dart';
import '../../helper/styles/app_style_sheet.dart';

AppBar customAppBar(
    {required dynamic title,
    dynamic leading,
    dynamic action,
    Color color = AppColors.primaryColor,
    bool autoLeading = true,
    bool centerTitle = false}) {
  return AppBar(
    centerTitle: centerTitle,
    backgroundColor: color,
    leading: leading,
    title: title,
    actions: action,
    automaticallyImplyLeading: autoLeading,
  );
}
