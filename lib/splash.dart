// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/helper/styles/app_style_sheet.dart';
import 'package:whatsapp_clone/tab_bar/tab_bar.dart';
import 'auth/register_view.dart';
import 'components/Loader/button_loader.dart';
import 'database_event/event_listner.dart';
import 'getter_setter/getter_setter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    isLogin();

    super.initState();
  }

  Future<bool> rebuild() async {
    if (!mounted) return false;
    // if there's a current frame,
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      // wait for the end of that frame.
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return false;
    }
    setState(() {});
    return true;
  }

  isLogin() async {
    if (sharedPrefs!.getBool("isLogin") == true) {
      if (!await rebuild()) return;
      var provider = Provider.of<GetterSetterModel>(context, listen: false);
      provider.removeChatRoom();
      DatabaseEventListner(context: context, provider: provider).getAllUsers();
      DatabaseEventListner(context: context, provider: provider)
          .getAllChatRooms();
      DatabaseEventListner(context: context, provider: provider)
          .getGroupChatRooms();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeTabBar(
                    currentIndex: 1,
                  )),
          (route) => false);
    } else {
      if (!await rebuild()) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
          (route) => false);
    }
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
              const ButtonLoader(),
            ],
          ),
        ),
      ),
    );
  }
}
