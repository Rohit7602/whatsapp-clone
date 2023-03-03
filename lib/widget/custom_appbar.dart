import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';

customAppBar(
    {required String title,
    dynamic leading,
    dynamic action,
    Color color = primaryColor,
    bool autoLeading = true}) {
  return AppBar(
    backgroundColor: color,
    leading: leading,
    title: Text(title),
    actions: action,
    automaticallyImplyLeading: autoLeading,
  );
}
