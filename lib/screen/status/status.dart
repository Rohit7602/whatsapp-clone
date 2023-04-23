import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context).userModel;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: InkWell(
        onTap: () {
          
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          height: 70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(provider.profileImage))),
                  ),
                  Positioned(
                    right: 10,
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor),
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Status",
                    style: GetTextTheme.sf16_medium,
                  ),
                  AppServices.addHeight(2),
                  Text(
                    "Tap to add status update",
                    style: GetTextTheme.sf14_regular
                        .copyWith(color: AppColors.greyColor),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                  child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                ),
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.camera_alt),
        onPressed: () {},
      ),
    );
  }
}
