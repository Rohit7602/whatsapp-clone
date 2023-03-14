// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helper/styles/app_style_sheet.dart';

Stack userProfileAvtar(File? pickedFile, onTap) {
  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 20.h),
        height: 150.h,
        width: 150.w,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
            shape: BoxShape.circle,
            color: AppColors.greyColor.withOpacity(0.2)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: pickedFile == null
              ? Image.asset(
                  AppImages.defaultImage,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(
                    pickedFile.path,
                  ),
                  fit: BoxFit.cover,
                ),
        ),
      ),
      Positioned(
        right: 15.w,
        bottom: 20.h,
        child: GestureDetector(
          onTap: () => onTap(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ),
    ],
  );
}
