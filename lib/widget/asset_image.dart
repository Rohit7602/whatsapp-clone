// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import '../helper/base_getters.dart';

Container CustomAssetImage(BuildContext context, double height,
    String assetImage, EdgeInsetsGeometry? margin) {
  return Container(
    margin: margin,
    height: height,
    width: AppServices.getScreenWidth(context),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(assetImage),
      ),
    ),
  );
}