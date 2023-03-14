import 'package:flutter/material.dart';

import '../helper/styles/app_style_sheet.dart';

showLoading() {
  return const Center(
      child: CircularProgressIndicator(
    color: AppColors.primaryColor,
  ));
}
