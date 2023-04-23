import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:flutter/material.dart';

class ShowSnackbar {
  BuildContext context;
  String message;
  ShowSnackbar({required this.context, required this.message});

  final double snackBarDuration = 3;

  success() => FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.success,
        title: "SUCCESS",
        message: message,
        duration: snackBarDuration,
      );
  error() => FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.error,
        title: "oops! ERROR",
        message: message,
        duration: snackBarDuration,
      );
  info() => FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.info,
        title: "SUCCESS",
        message: message,
        duration: snackBarDuration,
      );
  warning() => FancySnackbar.showSnackbar(
        context,
        snackBarType: FancySnackBarType.warning,
        title: "WARNING",
        message: message,
        duration: snackBarDuration,
      );
}
