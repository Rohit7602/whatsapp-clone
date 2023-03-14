// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member, use_build_context_synchronously, must_be_immutable, non_constant_identifier_names

import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/components/profile_avatar.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/widget/Custom_TextField/suffxIcon_field.dart';
import 'package:whatsapp_clone/widget/custom_button.dart';
import 'package:whatsapp_clone/widget/pick_mobile_image.dart';
import '../components/show_loading.dart';
import '../components/text_field_empty_error.dart';
import '../components/upload_image_db.dart';
import '../function/custom_appbar.dart';
import '../helper/base_getters.dart';
import '../helper/styles/app_style_sheet.dart';
import 'components/create_user.dart';

class UserProfileScreen extends StatefulWidget {
  String phoneNumber;

  UserProfileScreen({required this.phoneNumber, super.key});

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 22.0.w, vertical: 18.h),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      userProfileAvtar(pickedFile, () async {
                        await showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(18.sp),
                                    topRight: Radius.circular(18.sp))),
                            context: context,
                            builder: (_) {
                              return const ImagePickerFunction();
                            }).then((value) {
                          setState(() {
                            pickedFile = value;
                          });
                        });
                      }),
                      AppServices.addHeight(20.h),
                      SecondaryTextFieldView(
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
                      AppServices.addHeight(20.h),
                      SecondaryTextFieldView(
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
                      AppServices.addHeight(30.h),
                      provider.isLoading
                          ? showLoading()
                          : SaveProfileButton(context, provider),
                    ],
                  ),
                ),
              ),
              if (showEmoji)
                SizedBox(
                  height: 300.h,
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

  CustomButton SaveProfileButton(
      BuildContext context, GetterSetterModel provider) {
    return CustomButton(
      btnName: "Save Profile",
      onTap: () async {
        AppServices.keyboardUnfocus(context);
        if (_key.currentState!.validate() && pickedFile != null) {
          provider.loadingState(true);

          downloadUrl = await uploadImageOnDb("profile_image", pickedFile);
          if (downloadUrl.isNotEmpty) {
            AppServices.keyboardUnfocus(context);
            createUser(context, nameController, widget.phoneNumber,
                descriptionController, downloadUrl, provider);
          } else {
            provider.loadingState(false);
          }
        }
      },
    );
  }
}
