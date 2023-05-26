import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';

class FlutterAwesomeDialog {
  static AwesomeDialog deleteConfirmationDialog(
      BuildContext context, Function? onOk) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: "Confirm Delete",
        desc: "Are you sure you want to remove this item?",
        btnCancelOnPress: () {},
        btnOkOnPress: onOk != null ? () => onOk() : null)
      ..show();
  }
}
