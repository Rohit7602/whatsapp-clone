// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/components/awesome_dialog.dart';
import 'package:whatsapp_clone/components/custom_appbar.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import 'package:whatsapp_clone/helper/styles/app_style_sheet.dart';
import '../../model/status_model.dart';

class MyAllStatus extends StatelessWidget {
  List<StatusModel> statusModel;
  MyAllStatus({required this.statusModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          title: const Text("My Status"),
          autoLeading: true,
          color: AppColors.primaryColor),
      body: SafeArea(
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                color: AppColors.greyColor.shade200,
              );
            },
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: statusModel.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  children: [
                    const Text("10"),
                    AppServices.addWidth(5),
                    const Icon(Icons.remove_red_eye, size: 15),
                    AppServices.addWidth(5),
                    Text(
                      "Views",
                      style: GetTextTheme.sf12_regular,
                    ),
                  ],
                ),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(statusModel[index].image),
                          fit: BoxFit.cover),
                      shape: BoxShape.circle,
                      color: AppColors.greyColor),
                ),
                trailing: IconButton(
                    onPressed: () =>
                        FlutterAwesomeDialog.deleteConfirmationDialog(
                            context, () {}),
                    icon: const Icon(Icons.delete)),
              );
            }),
      ),
    );
  }

  deleteStatus(statusId) async {
// GetFirebaseRef.getMyStatus().
  }
}
