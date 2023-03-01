import 'package:flutter/material.dart';

pushTo(context, pushto) {
  return Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => pushto));
}

pushToAndRemove(context, pushtoRemove) {
  return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => pushtoRemove), (route) => false);
}

popView(context) {
  return Navigator.of(context).pop();
}

unfocus(context) {
  return FocusScope.of(context).unfocus();
}

sizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

showLoading() {
  return const Center(child: CircularProgressIndicator());
}
