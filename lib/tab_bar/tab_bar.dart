// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/auth/register.dart';
import 'package:whatsapp_clone/splash.dart';
import '../screen/call/recent_calls.dart';
import '../screen/group_chat/group_screen.dart';
import '../screen/home/homepage.dart';
import '../screen/status/status.dart';
import '../styles/stylesheet.dart';
import '../styles/textTheme.dart';
import '../widget/custom_widget.dart';

class HomeTabBar extends StatefulWidget {
  int currentIndex;
  HomeTabBar({required this.currentIndex, super.key});

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> with TickerProviderStateMixin {
  TabController? tabController;
  var navigatorKey = GlobalKey<NavigatorState>();
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    tabController = TabController(
        initialIndex: widget.currentIndex, vsync: this, length: 4);

    super.initState();
  }

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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Press back again to exist"),
            ),
          );
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          toolbarHeight: 115,
          title: Column(
            children: [
              sizedBox(10),
              Row(
                children: [
                  Text(
                    "Hex Chat",
                    style: TextThemeProvider.heading1.copyWith(
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: whiteColor),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: whiteColor),
                  ),
                  IconButton(
                    onPressed: () async {
                      PopupMenuButton(itemBuilder: (context) {
                        return [
                          const PopupMenuItem<int>(
                            value: 0,
                            child: Text("My Account"),
                          ),
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Text("Settings"),
                          ),
                          const PopupMenuItem<int>(
                            value: 2,
                            child: Text("Logout"),
                          ),
                        ];
                      }, onSelected: (value) {
                        if (value == 0) {
                          print("My account menu is selected.");
                        } else if (value == 1) {
                          print("Settings menu is selected.");
                        } else if (value == 2) {
                          print("Logout menu is selected.");
                        }
                      });
                      // showPopupMenu();
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();

                      // prefs.clear();
                      // pushToAndRemove(context, const RegisterScreen());
                    },
                    icon: const Icon(Icons.more_vert, color: whiteColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TabBar(
                labelStyle: TextThemeProvider.bodyTextSmall
                    .copyWith(fontWeight: FontWeight.bold),
                automaticIndicatorColorAdjustment: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 4,
                isScrollable: true,
                labelColor: whiteColor,
                indicatorColor: whiteColor,
                unselectedLabelColor: whiteColor,
                controller: tabController,
                tabs: [
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: const Icon(Icons.groups)),
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: const Text("CHATS")),
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: const Text("STATUS")),
                  Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: const Text("CALLS")),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            const GroupScreen(),
            HomePageScreen(),
            const StatusScreen(),
            const RecentCallsScreen()
          ],
        ),
      ),
    );
  }

  void showPopupMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(10, 10, 0, 10),
      items: [
        PopupMenuItem(
          onTap: () {
            getNavigation("1");
          },
          value: "1",
          child: const Text(
            "New Group",
          ),
        ),
        PopupMenuItem(
          onTap: () => getNavigation("2"),
          value: "2",
          child: const Text(
            "Settings",
          ),
        ),
        PopupMenuItem(
          onTap: () {},
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
        return pushTo(context, const SplashScreen());
      case "2":
        return pushTo(context, const RegisterScreen());
      case "3":
        return pushTo(context, const SplashScreen());

      default:
        return null;
    }
  }
}
