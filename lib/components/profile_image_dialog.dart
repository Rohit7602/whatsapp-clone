// ignore_for_file: use_build_context_synchronously, must_be_immutable, sized_box_for_whitespace, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../getter_setter/getter_setter.dart';
import '../model/user_model.dart';
import '../widget/custom_instance.dart';
import '../widget/custom_widget.dart';
import '../widget/upload_image_db.dart';

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
    var provider = Provider.of<GetterSetterModel>(context);
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
          getHeight(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 3,
                child: IconButton(
                  onPressed: () {
                    widget.profileUrl = "";
                    popView(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
              Flexible(
                flex: 1,
                child: getWidth(
                  10,
                ),
              ),
              Flexible(
                flex: 3,
                child: provider.isLoading
                    ? showLoading()
                    : IconButton(
                        onPressed: () async {
                          provider.loadingState(false);
                          if (widget.imageFile!.path.isNotEmpty) {
                            provider.loadingState(true);
                            uploadImage();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter name"),
                              ),
                            );
                            provider.loadingState(false);
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
              pathUser.value as Map<Object?, Object?>, pathUser.key.toString());

          userProvider.getUserModel(fetchData);
          provider.loadingState(false);
          setState(() {
            widget.imageFile == null;
          });

          popView(context);
        } else {
          print("Download url is empty");
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
