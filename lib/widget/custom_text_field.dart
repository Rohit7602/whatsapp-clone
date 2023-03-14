// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helper/styles/app_style_sheet.dart';

// get TextField Of the screen

class CustomTextFieldView extends StatelessWidget {
  TextEditingController? controller;
  String hint;
  String label;
  bool isSecure;
  dynamic suffixIcon;
  bool suffixIconEnable;
  bool numpad;
  int maxLines;
  bool readOnly;
  bool isObsecure;
  bool isDisabled;
  bool capitalText;
  Function? onTap;
  dynamic validator;
  Function(String)? onChange;
  bool prefixIconEnable;
  dynamic prefixIcon;

  CustomTextFieldView(
      {Key? key,
      this.controller,
      this.hint = "",
      this.label = "",
      this.isSecure = false,
      this.suffixIcon,
      this.suffixIconEnable = false,
      this.isObsecure = false,
      this.numpad = false,
      this.readOnly = false,
      this.maxLines = 1,
      this.isDisabled = false,
      this.capitalText = true,
      this.onTap,
      this.validator,
      this.onChange,
      this.prefixIconEnable = false,
      this.prefixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        label.isNotEmpty
            ? Text(
                label,
                style: GetTextTheme.sf16_regular.copyWith(
                  color: isDisabled
                      ? AppColors.blackColor.withOpacity(0.1)
                      : AppColors.greyColor,
                ),
              )
            : const SizedBox(),
        Container(
          margin: EdgeInsets.only(top: 5.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.whiteColor,
              border: Border.all(color: AppColors.primaryColor)),
          child: TextFormField(
            style: GetTextTheme.sf18_regular,
            textCapitalization: capitalText
                ? TextCapitalization.words
                : TextCapitalization.none,
            maxLines: maxLines,
            readOnly: readOnly,
            keyboardType: numpad ? TextInputType.phone : TextInputType.text,
            controller: controller,
            validator: validator,
            onChanged: onChange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.sp, 10.sp, 10.sp, 10.sp),
              prefixIcon: prefixIconEnable
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [prefixIcon],
                    )
                  : null,
              suffixIcon: suffixIconEnable
                  ? IconButton(
                      onPressed: null,
                      icon: suffixIcon,
                    )
                  : null,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: hint,
              hintStyle: GetTextTheme.sf16_regular.copyWith(
                  color: isDisabled
                      ? AppColors.blackColor.withOpacity(0.1)
                      : AppColors.greyColor),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }
}
