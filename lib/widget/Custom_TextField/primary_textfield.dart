// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';

class PrimaryTextFieldView extends StatelessWidget {
  TextEditingController? controller;
  dynamic prefixIcon;

  String hintText;
  String fieldEmptyError;
  Function(String)? onChange;
  String? Function(String?)? validator;

  PrimaryTextFieldView(
      {this.controller,
      this.prefixIcon,
      this.hintText = "",
      this.fieldEmptyError = "",
      this.onChange,
      this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      onChanged: onChange,
      style: GetTextTheme.sf14_regular,
      validator: validator,
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
          prefixIcon: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [AppServices.addWidth(10), prefixIcon],
          ),
          hintText: hintText,
          hintStyle: GetTextTheme.sf14_regular
              .copyWith(color: AppColors.blackColor.withOpacity(0.3)),
          enabledBorder: fieldBorderOutline(),
          focusedBorder: fieldBorderOutline(),
          focusedErrorBorder: fieldBorderOutline(),
          border: fieldBorderOutline()),
    );
  }
}

String? Function(String?)? phoneNumbeValidator() {
  return (value) {
    if (value!.length != 10) {
      return "Please Enter Phone Number";
    } else {
      return null;
    }
  };
}

// User this function to decorate Primary TextField View

OutlineInputBorder fieldBorderOutline() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryColor));
}
