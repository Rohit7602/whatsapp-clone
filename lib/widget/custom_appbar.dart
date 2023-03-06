import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';

customAppBar(
    {required dynamic title,
    dynamic leading,
    dynamic action,
    Color color = primaryColor,
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
