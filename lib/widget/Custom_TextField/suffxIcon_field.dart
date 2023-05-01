// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import 'package:whatsapp_clone/widget/Custom_TextField/primary_textfield.dart';
import '../../helper/styles/app_style_sheet.dart';

class SecondaryTextFieldView extends StatelessWidget {
  TextEditingController? controller;
  dynamic suffixIcon;
  dynamic prefixIcon;
  String hintText;
  String fieldEmptyError;
  bool readOnly;
  Function(String)? onChange;
  String? Function(String?)? validator;

  SecondaryTextFieldView(
      {this.controller,
      this.suffixIcon,
      this.prefixIcon,
      this.hintText = "",
      this.fieldEmptyError = "",
      this.readOnly = false,
      this.onChange,
      this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly ? true : false,
      textCapitalization: TextCapitalization.words,
      onChanged: onChange,
      style: GetTextTheme.sf14_regular,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
          suffixIcon: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [AppServices.addWidth(10), suffixIcon ?? SizedBox()],
          ),
          prefixIcon: prefixIcon,
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
