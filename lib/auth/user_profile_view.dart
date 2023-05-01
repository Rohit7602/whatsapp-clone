// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, use_build_context_synchronously, must_be_immutable, non_constant_identifier_names

import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/components/Loader/full_screen_loader.dart';
import 'package:whatsapp_clone/components/profile_avatar.dart';
import 'package:whatsapp_clone/components/snackbars/valt_snackbar.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/widget/Custom_TextField/suffxIcon_field.dart';
import 'package:whatsapp_clone/widget/custom_button.dart';
import 'package:whatsapp_clone/widget/pick_mobile_image.dart';
import '../components/text_field_empty_error.dart';
import '../components/custom_appbar.dart';
import '../controller/firebase_controller.dart';
import '../helper/base_getters.dart';
import '../helper/styles/app_style_sheet.dart';

class UserProfileScreen extends StatefulWidget {
  String phoneNumber;
  String otpCode;

  UserProfileScreen(
      {required this.phoneNumber, required this.otpCode, super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
      backgroundColor: AppColors.whiteColor,
      appBar: customAppBar(
        title: Text(
          "Complete your profile",
          style: GetTextTheme.sf20_medium,
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          AppServices.keyboardUnfocus(context);
          setState(() {
            showEmoji = false;
          });
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 18),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: userProfileAvtar(pickedFile, () async {
                              await showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(18),
                                          topRight: Radius.circular(18))),
                                  context: context,
                                  builder: (_) {
                                    return const ImagePickerFunction();
                                  }).then((value) {
                                setState(() {
                                  pickedFile = value;
                                });
                              });
                            }),
                          ),
                          AppServices.addHeight(20),
                          const Text("Your Number"),
                          AppServices.addHeight(10),
                          SecondaryTextFieldView(
                            readOnly: true,
                            prefixIcon: const Icon(Icons.phone),
                            hintText: widget.phoneNumber,
                          ),
                          AppServices.addHeight(20),
                          const Text("Enter Your Name"),
                          AppServices.addHeight(10),
                          SecondaryTextFieldView(
                            prefixIcon: const Icon(Icons.person),
                            validator: fieldEmptyValidation("Name"),
                            controller: nameController,
                            hintText: "Enter your name",
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          AppServices.addHeight(20),
                          const Text("Enter Your Description"),
                          AppServices.addHeight(10),
                          SecondaryTextFieldView(
                            prefixIcon: const Icon(Icons.description),
                            validator: fieldEmptyValidation("Description"),
                            controller: descriptionController,
                            hintText: "Enter your description",
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          AppServices.addHeight(30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SaveProfileButton(context, provider),
                            ],
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
            provider.isLoading ? const FullScreenLoader() : const SizedBox()
          ],
        ),
      ),
    );
  }

  CustomButton SaveProfileButton(
      BuildContext context, GetterSetterModel provider) {
    return CustomButton(
      btnName: "Save Profile",
      onTap: () async {
        AppServices.keyboardUnfocus(context);
        if (_key.currentState!.validate()) {
          if (pickedFile != null) {
            provider.loadingState(true);
            Map<String, dynamic> profileForm = {
              "Name": nameController.text.trim(),
              "Number": widget.phoneNumber,
              "ProfileImage": pickedFile,
              "Description": descriptionController.text.trim(),
            };
            provider.profileForm.addAll(profileForm);

            FirebaseController(context, provider)
                .sendOTP(context, widget.phoneNumber);
          } else {
            ShowSnackbar(context: context, message: "Please upload image")
                .error();
          }
        }
      },
    );
  }
}
  //  provider.loadingState(true);

  //         downloadUrl = await uploadImageOnDb("profile_image", pickedFile);

  //         if (downloadUrl.isNotEmpty) {
  //           FirebaseController(context, provider).createUser(
  //               context,
  //               nameController,
  //               widget.phoneNumber,
  //               descriptionController,
  //               downloadUrl);
  //         } else {
  //           provider.loadingState(false);
  //         }