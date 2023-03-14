// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/helper/styles/app_style_sheet.dart';
import 'package:whatsapp_clone/tab_bar/tab_bar.dart';
import 'auth/register_view.dart';
import 'components/show_loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  isLogin() async {
    if (sharedPrefs!.getBool("isLogin") == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeTabBar()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
          (route) => false);
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      isLogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.appLogo,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              const SizedBox(height: 20.0),
              showLoading(),
            ],
          ),
        ),
      ),
    );
  }
}
