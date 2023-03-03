// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, use_build_context_synchronously

import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_clone/widget/custom_button.dart';
import 'package:whatsapp_clone/widget/custom_text_field.dart';
import '../main.dart';
import '../screen/home/homepage.dart';
import '../styles/stylesheet.dart';
import '../styles/textTheme.dart';
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
  bool isLoading = false;
  bool showEmoji = false;
  String downloadUrl = "";

  @override
  Widget build(BuildContext context) {
    print("Download URL Checker ::: $downloadUrl");
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: const Text("Complete your profile"),
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
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: greyColor.withOpacity(0.4)),
                                  shape: BoxShape.circle,
                                  color: greyColor.withOpacity(0.2)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: pickedFile == null
                                    ? Image.asset(
                                        "asset/default_image.png",
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(
                                          pickedFile!.path,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                              )),
                          Positioned(
                            right: 15,
                            bottom: 20,
                            child: GestureDetector(
                              onTap: () {
                                modalBottomSheet();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: blackColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      sizedBox(20),
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
                      sizedBox(15),
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
                      sizedBox(30),
                      isLoading
                          ? showLoading()
                          : CustomButton(
                              btnName: "Save Profile",
                              onTap: () async {
                                unfocus(context);
                                if (_key.currentState!.validate() &&
                                    pickedFile != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  downloadUrl = await uploadImageOnDb(
                                      "profile_image", pickedFile);
                                  if (downloadUrl.isNotEmpty) {
                                    unfocus(context);
                                    createUser();
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
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

  createUser() async {
    try {
      Map<String, dynamic> bodyData = {
        "Name": nameController.text,
        "Number": widget.phoneNumber,
        "Description": descriptionController.text,
        "UserId": auth.currentUser!.uid,
        "ProfileImage": downloadUrl.isEmpty ? "" : downloadUrl,
        "CreatedOn": DateTime.now().toIso8601String(),
      };

      await database
          .ref("users/${auth.currentUser!.uid}")
          .set(bodyData)
          .then((value) async {
        if (mounted) {
          sharedPrefs!.setBool("isLogin", true);

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Register Success")));
          pushToAndRemove(
              context,
              HomeTabBar(
                currentIndex: 1,
              ));
          setState(() {
            isLoading = false;
          });
        } else {
          print("Not Mounted");
          setState(() {
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
