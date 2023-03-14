import 'package:flutter/material.dart';

showSnackBar(context, msg) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}
