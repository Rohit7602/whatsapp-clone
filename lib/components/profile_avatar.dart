// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';

import '../styles/stylesheet.dart';
import '../widget/custom_image.dart';

Stack profileAvatar(pickedFile, onTap) {
  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
            border: Border.all(color: greyColor.withOpacity(0.4)),
            shape: BoxShape.circle,
            color: greyColor.withOpacity(0.2)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: pickedFile == null
              ? Image.asset(
                  defaultImage,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(
                    pickedFile!.path,
                  ),
                  fit: BoxFit.cover,
                ),
        ),
      ),
      Positioned(
        right: 15,
        bottom: 20,
        child: GestureDetector(
          onTap: () => onTap(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              color: whiteColor,
            ),
          ),
        ),
      ),
    ],
  );
}
