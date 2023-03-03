import 'package:flutter/material.dart';
import 'package:whatsapp_clone/styles/stylesheet.dart';

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
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDisabled ? blackColor.withOpacity(0.4) : whiteColor,
          border: Border.all(color: primaryColor.withOpacity(0.6))),
      child: TextFormField(
        textCapitalization:
            capitalText ? TextCapitalization.words : TextCapitalization.none,
        maxLines: maxLines,
        readOnly: readOnly,
        keyboardType: numpad ? TextInputType.phone : TextInputType.text,
        controller: controller,
        validator: validator,
        onChanged: onChange,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          suffixIcon: suffixIconEnable
              ? IconButton(
                  onPressed: null,
                  icon: suffixIcon,
                  color: primaryColor,
                )
              : null,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: label == ""
              ? null
              : Text(" $label ",
                  style: TextStyle(
                      color: isDisabled
                          ? blackColor.withOpacity(0.1)
                          : blackColor)),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintText: hint,
          hintStyle: TextStyle(
              color: isDisabled ? blackColor.withOpacity(0.1) : greyColor),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
