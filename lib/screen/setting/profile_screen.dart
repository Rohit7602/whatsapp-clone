// ignore_for_file: use_build_context_synchronously, must_be_immutable, avoid_print, sized_box_for_whitespace

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:whatsapp_clone/components/profile_avatar.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/widget/custom_button.dart';
import 'package:whatsapp_clone/widget/custom_text_field.dart';
import '../../components/Loader/button_loader.dart';
import '../../components/profile_image_dialog.dart';
import '../../components/custom_appbar.dart';
import '../../controller/image_controller.dart';
import '../../helper/base_getters.dart';
import '../../helper/global_function.dart';
import '../../helper/styles/app_style_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  File? pickedFile;
  @override
  Widget build(BuildContext context) {
    var userdata = Provider.of<GetterSetterModel>(context);
    return Scaffold(
      appBar: customAppBar(title: const Text("Profile")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          userProfileAvtar(pickedFile, () {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18))),
              context: context,
              builder: (_) {
                return ProfileImageBottomSheet(
                  profileUrl: userdata.userModel.profileImage,
                );
              },
            );
          }),
          ListTile(
            leading: const Icon(Icons.person_2),
            title: Text(
              "Name",
              style:
                  GetTextTheme.sf12_medium.copyWith(color: AppColors.greyColor),
            ),
            subtitle:
                Text(userdata.userModel.name, style: GetTextTheme.sf16_medium),
            trailing: IconButton(
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return NameModalBottomSheet(
                        userName: userdata.userModel.name,
                        controller: nameController,
                      );
                    }),
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.primaryColor,
                )),
          ),
          Container(
            padding: const EdgeInsets.only(left: 70),
            child: Text(
              "This is not your username or pin. This name will me visible to your Hex Chat contacts.",
              style: GetTextTheme.sf14_regular
                  .copyWith(color: AppColors.greyColor),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 70),
            margin: const EdgeInsets.only(top: 15, bottom: 5),
            child: const Divider(
              color: AppColors.greyColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(
              "About",
              style: GetTextTheme.sf12_regular
                  .copyWith(color: AppColors.greyColor),
            ),
            subtitle: Text(userdata.userModel.description,
                style: GetTextTheme.sf26_medium),
            trailing: IconButton(
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return DescriptionModalBottomSheet(
                        description: userdata.userModel.description,
                        controller: descriptionController,
                      );
                    }),
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.primaryColor,
                )),
          ),
          Container(
            padding: const EdgeInsets.only(left: 70),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: const Divider(
              color: AppColors.greyColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(
              "Phone",
              style:
                  GetTextTheme.sf12_medium.copyWith(color: AppColors.greyColor),
            ),
            subtitle: Text("+91 ${userdata.userModel.number}",
                style: GetTextTheme.sf12_medium),
          ),
          AppServices.addHeight(30),
          Text("Powered by Hex Chat", style: GetTextTheme.sf12_medium)
        ],
      ),
    );
  }
}

class ProfileImageBottomSheet extends StatefulWidget {
  String profileUrl;
  ProfileImageBottomSheet({required this.profileUrl, super.key});

  @override
  State<ProfileImageBottomSheet> createState() =>
      _ProfileImageBottomSheetState();
}

class _ProfileImageBottomSheetState extends State<ProfileImageBottomSheet> {
  File? pickedFile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Profile Photo",
            style:
                GetTextTheme.sf18_medium.copyWith(color: AppColors.greyColor),
          ),
          AppServices.addHeight(25),
          Row(
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      AppServices.popView(context);
                      pickedFile = await ImageController.pickImageWithCamera();

                      showDialog(
                          context: context,
                          builder: (_) {
                            return ImageDialog(
                              profileUrl: widget.profileUrl,
                              imageFile: pickedFile,
                            );
                          });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.greyColor.shade300, width: 1)),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  Text("Camera", style: GetTextTheme.sf16_medium),
                ],
              ),
              AppServices.addWidth(
                30,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      pickedFile = await ImageController.pickImageWithGallery();

                      setState(() {
                        pickedFile;
                      });
                      AppServices.popView(context);
                      showDialog(
                          context: context,
                          builder: (_) {
                            return ImageDialog(
                              profileUrl: widget.profileUrl,
                              imageFile: pickedFile,
                            );
                          });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.greyColor.shade300, width: 1)),
                      child: const Icon(
                        Icons.image,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  Text("Gallery", style: GetTextTheme.sf16_medium),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NameModalBottomSheet extends StatefulWidget {
  String userName;
  TextEditingController controller;
  NameModalBottomSheet(
      {required this.userName, required this.controller, super.key});

  @override
  State<NameModalBottomSheet> createState() => _NameModalBottomSheetState();
}

class _NameModalBottomSheetState extends State<NameModalBottomSheet> {
  final database = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enter your name",
            style: GetTextTheme.sf16_regular,
          ),
          AppServices.addHeight(20),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CustomTextFieldView(
              controller: widget.controller,
              hint: widget.userName,
            ),
          ),
          AppServices.addHeight(20),
          Row(
            children: [
              Flexible(
                  flex: 3,
                  child: CustomButton(
                      btnName: "Cancel",
                      onTap: () => AppServices.popView(context))),
              Flexible(
                flex: 1,
                child: AppServices.addWidth(10),
              ),
              Flexible(
                  flex: 3,
                  child: isLoading
                      ? const ButtonLoader()
                      : CustomButton(
                          btnName: "Save",
                          onTap: () async {
                            if (widget.controller.text.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                              var userProvider = Provider.of<GetterSetterModel>(
                                  context,
                                  listen: false);
                              await database
                                  .ref("users/${auth.currentUser!.uid}")
                                  .update({"Name": widget.controller.text});

                              var pathUser = await database
                                  .ref("users/${auth.currentUser!.uid}")
                                  .get();

                              var fetchData = UserModel.fromJson(
                                pathUser.value as Map<Object?, Object?>,
                                pathUser.key.toString(),
                              );

                              userProvider.getUserModel(fetchData);
                              setState(() {
                                isLoading = false;
                              });
                              AppServices.popView(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please enter name")));
                              setState(() {
                                isLoading = false;
                              });
                            }
                          })),
            ],
          ),
          AppServices.addHeight(20),
        ],
      ),
    );
  }
}

class DescriptionModalBottomSheet extends StatefulWidget {
  String description;
  TextEditingController controller;
  DescriptionModalBottomSheet(
      {required this.description, required this.controller, super.key});

  @override
  State<DescriptionModalBottomSheet> createState() =>
      _DescriptionModalBottomSheetState();
}

class _DescriptionModalBottomSheetState
    extends State<DescriptionModalBottomSheet> {
  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enter your description",
            style: GetTextTheme.sf16_regular,
          ),
          AppServices.addHeight(20),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CustomTextFieldView(
              controller: widget.controller,
              hint: widget.description,
            ),
          ),
          AppServices.addHeight(20),
          Row(
            children: [
              Flexible(
                  flex: 3,
                  child: CustomButton(
                      btnName: "Cancel", onTap: () => isLoading = false)),
              Flexible(
                flex: 1,
                child: AppServices.addWidth(
                  10,
                ),
              ),
              Flexible(
                  flex: 3,
                  child: isLoading
                      ? const ButtonLoader()
                      : CustomButton(
                          btnName: "Save",
                          onTap: () async {
                            if (widget.controller.text.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                              var userProvider = Provider.of<GetterSetterModel>(
                                  context,
                                  listen: false);
                              await database
                                  .ref("users/${auth.currentUser!.uid}")
                                  .update(
                                      {"Description": widget.controller.text});

                              var pathUser = await database
                                  .ref("users/${auth.currentUser!.uid}")
                                  .get();

                              var fetchData = UserModel.fromJson(
                                  pathUser.value as Map<Object?, Object?>,
                                  pathUser.key.toString());

                              userProvider.getUserModel(fetchData);
                              setState(() {
                                isLoading = false;
                              });
                              AppServices.popView(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please enter name")));
                              setState(() {
                                isLoading = false;
                              });
                            }
                          })),
            ],
          ),
          AppServices.addHeight(20),
        ],
      ),
    );
  }
}



 // Stack(
          //   alignment: Alignment.bottomRight,
          //   children: [
          //     Container(
          //       margin: const EdgeInsets.symmetric(vertical: 20),
          //       height: 150,
          //       width: 150,
          //       decoration: BoxDecoration(
          //           border: Border.all(color: greyColor.withOpacity(0.4)),
          //           shape: BoxShape.circle,
          //           color: greyColor.withOpacity(0.2)),
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(100),
          //         child: userdata.userModel.profileImage.isEmpty
          //             ? Image.asset(
          //                 "asset/default_image.png",
          //                 fit: BoxFit.cover,
          //               )
          //             : Image.network(
          //                 userdata.userModel.profileImage,
          //                 fit: BoxFit.cover,
          //               ),
          //       ),
          //     ),
          //     Positioned(
          //       right: 15,
          //       bottom: 20,
          //       child: GestureDetector(
          //         onTap: () {
          //           showModalBottomSheet(
          //             shape: const RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(18),
          //                     topRight: Radius.circular(18))),
          //             context: context,
          //             builder: (_) {
          //               return ProfileImageBottomSheet(
          //                 profileUrl: userdata.userModel.profileImage,
          //               );
          //             },
          //           );
          //         },
          //         child: Container(
          //           padding: const EdgeInsets.all(8),
          //           decoration: BoxDecoration(
          //             color: primaryColor.withOpacity(0.7),
          //             shape: BoxShape.circle,
          //           ),
          //           child: const Icon(
          //             Icons.camera_alt,
          //             color: whiteColor,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),