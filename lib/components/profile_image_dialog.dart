// ignore_for_file: use_build_context_synchronously, must_be_immutable, sized_box_for_whitespace, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/components/upload_image_db.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import '../getter_setter/getter_setter.dart';
import '../helper/global_function.dart';
import '../model/user_model.dart';

class ImageDialog extends StatefulWidget {
  String profileUrl;
  File? imageFile;
  ImageDialog({required this.profileUrl, required this.imageFile, super.key});

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 300,
            child: Image.file(
              File(widget.imageFile!.path),
              fit: BoxFit.cover,
            ),
          ),
          AppServices.addHeight(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 3,
                child: IconButton(
                  onPressed: () {
                    widget.profileUrl = "";
                    AppServices.popView(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              Flexible(
                flex: 1,
                child: AppServices.addWidth(
                  10,
                ),
              ),
              Flexible(
                flex: 3,
                child: IconButton(
                  onPressed: () async {
                    if (widget.imageFile!.path.isNotEmpty) {
                      Navigator.of(context).pop(widget.imageFile);
                      // AppServices.popView(context);
                    }
                  },
                  icon: const Icon(Icons.check),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  uploadImage() async {
    try {
      var provider = Provider.of<GetterSetterModel>(context, listen: false);
      await storage.refFromURL(widget.profileUrl).delete().then((value) async {
        var downloadUrl =
            await uploadImageOnDb("profile_image", widget.imageFile);

        if (downloadUrl != null) {
          var userProvider =
              Provider.of<GetterSetterModel>(context, listen: false);
          await database
              .ref("users/${auth.currentUser!.uid}")
              .update({"ProfileImage": downloadUrl});

          var pathUser =
              await database.ref("users/${auth.currentUser!.uid}").get();

          var fetchData = UserModel.fromJson(
            pathUser.value as Map<Object?, Object?>,
            pathUser.key.toString(),
          );

          userProvider.getUserModel(fetchData);
          provider.loadingState(false);
          setState(() {
            widget.imageFile == null;
          });

          AppServices.popView(context);
        } else {
          print("Download url is empty");
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
