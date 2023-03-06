// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/components/profile_avatar.dart';
import 'package:whatsapp_clone/functions/create_user.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/widget/custom_appbar.dart';
import 'package:whatsapp_clone/widget/custom_button.dart';
import 'package:whatsapp_clone/widget/custom_image.dart';
import 'package:whatsapp_clone/widget/custom_text_field.dart';
import '../main.dart';
import '../styles/stylesheet.dart';
import '../tab_bar/tab_bar.dart';
import '../widget/custom_widget.dart';
import '../widget/upload_image_db.dart';

class UserProfileScreen extends StatefulWidget {
  String phoneNumber;

  UserProfileScreen({required this.phoneNumber, super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final database = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  File? pickedFile;

  bool showEmoji = false;
  String downloadUrl = "";

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: customAppBar(
        title: "Complete your profile",
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          unfocus(context);
          setState(() {
            showEmoji = false;
          });
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 18),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      profileAvatar(pickedFile, () {
                        modalBottomSheet();
                      }),
                      getHeight(20),
                      CustomTextFieldView(
                        capitalText: true,
                        onTap: () => unfocus(context),
                        hint: "Enter Your Name",
                        controller: nameController,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Please Enter name";
                          } else {
                            return null;
                          }
                        },
                        suffixIconEnable: true,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      getHeight(15),
                      CustomTextFieldView(
                        capitalText: true,
                        onTap: () {
                          unfocus(context);
                        },
                        hint: "Enter Your Description",
                        controller: descriptionController,
                        validator: (v) {
                          if (descriptionController.text.isEmpty) {
                            return "Please Enter Description";
                          } else {
                            return null;
                          }
                        },
                      ),
                      getHeight(30),
                      provider.isLoading
                          ? showLoading()
                          : CustomButton(
                              btnName: "Save Profile",
                              onTap: () async {
                                unfocus(context);
                                if (_key.currentState!.validate() &&
                                    pickedFile != null) {
                                  provider.loadingState(true);

                                  downloadUrl = await uploadImageOnDb(
                                      "profile_image", pickedFile);
                                  if (downloadUrl.isNotEmpty) {
                                    unfocus(context);
                                    createUser(
                                        context,
                                        nameController,
                                        widget.phoneNumber,
                                        descriptionController,
                                        downloadUrl,
                                        provider);
                                  } else {
                                    provider.loadingState(false);
                                  }
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
              if (showEmoji)
                SizedBox(
                  height: 300,
                  child: EmojiPicker(
                    textEditingController: nameController,
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  modalBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () async {
                  popView(context);
                  pickedFile = await pickImageWithCamera();
                  setState(() {
                    pickedFile;
                  });
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
              ),
              const Divider(),
              ListTile(
                onTap: () async {
                  popView(context);
                  pickedFile = await pickImageWithGallery();
                  setState(() {
                    pickedFile;
                  });
                },
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }
}
