// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';

import '../controller/image_controller.dart';
import '../helper/global_function.dart';
import '../helper/styles/app_style_sheet.dart';

class ImagePreviewScreen extends StatelessWidget {
  List<PickedFile> imageFile;
  ImagePreviewScreen({required this.imageFile, super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Center(
            //   child: Image.file(
            //     File(imageFile.path),
            //     width: AppServices.getScreenWidth(context),
            //   ),
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          AppServices.popView(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.whiteColor,
                        )),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: imageFile.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 5),
                              height: 60,
                              width: 50,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.file(
                                File(imageFile[index].path),
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
                AppServices.addHeight(100),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          onPressed: () => uploadStatusOnFirebase(context, provider),
          child: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.whiteColor),
                )
              : const Icon(
                  Icons.send,
                  color: AppColors.whiteColor,
                )),
    );
  }

  Future uploadStatusOnFirebase(
      BuildContext context, GetterSetterModel provider) async {
    try {
      provider.loadingState(true);

      for (var element in imageFile) {
        var getUrl =
            await ImageController.uploadImageOnDb("Status", File(element.path));

        Map<String, dynamic> data = {
          "Image": getUrl,
          "CreatedAt": DateTime.now().toIso8601String()
        };

        await database.ref("Status/${auth.currentUser!.uid}").push().set(data);
      }

      AppServices.popView(context);
      provider.loadingState(false);
    } catch (e) {
      print(e.toString());
      provider.loadingState(false);
    }
  }
}
