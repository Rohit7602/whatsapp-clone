import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/components/upload_image_db.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';

import '../../components/profile_image_dialog.dart';
import '../../function/custom_appbar.dart';
import '../../helper/styles/app_style_sheet.dart';
import '../../model/user_model.dart';
import '../../widget/Custom_TextField/suffxIcon_field.dart';

class CreateGroupScreen extends StatefulWidget {
  List<UserModel> groupMemberList;
  CreateGroupScreen({required this.groupMemberList, super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final groupNameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String profileUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        color: AppColors.primaryColor,
        title: Text("New Group", style: GetTextTheme.sf18_medium),
        action: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        // showModalBottomSheet(
                        //   shape: const RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(18),
                        //           topRight: Radius.circular(18))),
                        //   context: context,
                        //   builder: (_) {
                        //     return ProfileImageBottomSheet(
                        //       profileUrl: profileUrl,
                        //     );
                        //   },
                        // );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.greyColor),
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                  AppServices.addWidth(15),
                  Flexible(
                    flex: 2,
                    child: SecondaryTextFieldView(
                      suffixIcon: const Icon(Icons.emoji_emotions),
                      controller: groupNameController,
                      hintText: "Type group name..",
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Enter Group Name";
                        } else {
                          return "";
                        }
                      },
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(),
              ),
              Text("Participants: ${widget.groupMemberList.length}"),
              AppServices.addHeight(10),
              ListView.separated(
                  separatorBuilder: (context, i) {
                    return AppServices.addHeight(10);
                  },
                  shrinkWrap: true,
                  itemCount: widget.groupMemberList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.greyColor),
                          child: widget.groupMemberList[index].profileImage ==
                                  ""
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.whiteColor,
                                  size: 35,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    widget.groupMemberList[index].profileImage,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                      title: Text(
                        widget.groupMemberList[index].name,
                        style: GetTextTheme.sf14_regular,
                      ),
                      subtitle: Text(
                        widget.groupMemberList[index].description,
                        style: GetTextTheme.sf10_regular,
                      ),
                      trailing: widget.groupMemberList.length <= 3
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                index == 0
                                    ? null
                                    : setState(() {
                                        widget.groupMemberList.remove(
                                            widget.groupMemberList[index]);
                                      });
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index == 0
                                        ? AppColors.blueColor
                                        : AppColors.primaryColor),
                                child: Icon(
                                  index == 0 ? Icons.verified : Icons.close,
                                  color: AppColors.whiteColor,
                                  size: index == 0 ? 18 : 25,
                                ),
                              ),
                            ),
                    );
                  })
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          if (!_key.currentState!.validate()) return;
        },
        child: const Icon(Icons.check),
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
                      pickedFile = await pickImageWithCamera();

                      // ignore: use_build_context_synchronously
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
                      pickedFile = await pickImageWithGallery();

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
