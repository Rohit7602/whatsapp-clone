// ignore_for_file: use_build_context_synchronously, must_be_immutable, avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/app_config.dart';
import 'package:whatsapp_clone/auth/register_view.dart';
import 'package:whatsapp_clone/splash.dart';
import 'package:whatsapp_clone/function/snackbar.dart';
import '../helper/base_getters.dart';
import '../screen/call/recent_calls.dart';
import '../screen/group_chat/group_screen.dart';
import '../screen/home/homepage.dart';
import '../screen/status/status.dart';
import '../helper/styles/app_style_sheet.dart';

class HomeTabBar extends StatefulWidget {
  int currentIndex;
  HomeTabBar({this.currentIndex = 1, super.key});

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController? tabController;
  var navigatorKey = GlobalKey<NavigatorState>();
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    tabController = TabController(
        initialIndex: widget.currentIndex, vsync: this, length: 4);
    // WidgetsBinding.instance.addObserver(this);

    // setUserStatus(context, "online");
    super.initState();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     print("Online");
  //     setUserStatus(context, "online");
  //   } else {
  //     print("Offline");
  //     setUserStatus(context, "offline");
  //   }
  // }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExistWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();

        if (isExistWarning) {
          showSnackBar(context, "Press back again to exist");
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          toolbarHeight: 115,
          title: Column(
            children: [
              AppServices.addHeight(10),
              Row(
                children: [
                  Text(
                    AppConfig.appName,
                    style: GetTextTheme.sf20_medium.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: AppColors.whiteColor),
                  ),
                  IconButton(
                    onPressed: () {
                      getNavigation("2");
                    },
                    icon: const Icon(Icons.search, color: AppColors.whiteColor),
                  ),
                  IconButton(
                    onPressed: () async {
                      // showPopupMenu();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      prefs.clear();
                      AppServices.pushToAndRemove(
                          context, const RegisterScreen());
                    },
                    icon: const Icon(Icons.more_vert,
                        color: AppColors.whiteColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppTabBarView(),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            GroupScreen(),
            HomePageScreen(),
            StatusScreen(),
            RecentCallsScreen()
          ],
        ),
      ),
    );
  }

  TabBar AppTabBarView() {
    return TabBar(
      labelStyle: GetTextTheme.sf14_bold,
      automaticIndicatorColorAdjustment: true,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 4,
      isScrollable: true,
      labelColor: AppColors.whiteColor,
      indicatorColor: AppColors.whiteColor,
      unselectedLabelColor: AppColors.whiteColor,
      controller: tabController,
      tabs: [
        TabsController(const Icon(Icons.groups)),
        TabsController(const Text("CHATS")),
        TabsController(const Text("STATUS")),
        TabsController(const Text("CALLS")),
      ],
    );
  }

  Container TabsController(dynamic tabName) {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.only(bottom: 10),
        child: tabName);
  }

  void showPopupMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(10, 10, 0, 10),
      items: [
        PopupMenuItem(
          onTap: () => getNavigation("1"),
          value: "1",
          child: const Text(
            "New Group",
          ),
        ),
        PopupMenuItem(
          onTap: () {
            AppServices.popView(context);
            getNavigation("2");
          },
          value: "2",
          child: const Text(
            "Settings",
          ),
        ),
        PopupMenuItem(
          onTap: () => getNavigation("3"),
          value: "3",
          child: const Text(
            "Logout",
          ),
        ),
      ],
    );
  }

  getNavigation(String route) {
    switch (route) {
      case "1":
        return AppServices.pushTo(context, const SplashScreen());
      case "2":
        return AppServices.pushTo(context, const RegisterScreen());
      case "3":
        return AppServices.pushTo(context, const SplashScreen());

      default:
        return null;
    }
  }
}
