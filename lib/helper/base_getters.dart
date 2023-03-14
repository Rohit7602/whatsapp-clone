import 'package:flutter/material.dart';

class AppServices {
// get width of the screen
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

// get height of the screen
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

// used to add space between two vertical objects
  static addHeight(double space) => SizedBox(height: space);

// used to add space between two horizontal objects
  static addWidth(double space) => SizedBox(width: space);

// to check the screen is android or web
  static bool isSmallScreen(BuildContext context) =>
      getScreenWidth(context) <= 360;

// rupees currency symbol
  static String getCurrencySymbol = "\u{20B9}";

/*Navigation and routing*/

// Navigate a Screen
  static pushTo(BuildContext context, Widget screen) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => screen));

// Navigate Screen & Remove Behind Screen
  static pushToAndRemove(BuildContext context, Widget screen) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => screen));

// Pop View to Last Screen
  static popView(BuildContext context) => Navigator.of(context).pop();

// function to unfocus the keyboard on tap on screen
  static keyboardUnfocus(BuildContext context) =>
      FocusScope.of(context).unfocus();
}
