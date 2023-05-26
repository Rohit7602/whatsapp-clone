// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import '../../components/custom_appbar.dart';
import '../../controller/image_controller.dart';
import '../../helper/global_function.dart';
import '../../helper/styles/app_style_sheet.dart';
import '../../model/user_model.dart';
import '../../widget/Custom_TextField/suffxIcon_field.dart';
import 'group_screen/group_chatroom.dart';

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
  File? pickedFile;
  bool isLoading = false;

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
                      onTap: () async {
                        await showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18))),
                          context: context,
                          builder: (_) {
                            return ProfileImageBottomSheet(
                              profileUrl: profileUrl,
                            );
                          },
                        ).then((value) {
                          setState(() {
                            pickedFile = value;
                          });
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.greyColor),
                        child: pickedFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(File(pickedFile!.path)))
                            : const Icon(
                                Icons.camera_alt,
                                color: AppColors.whiteColor,
                              ),
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
              Expanded(
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
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
                                      widget
                                          .groupMemberList[index].profileImage,
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
                    }),
              )
            ],
          ),
        ),
      )),
      floatingActionButton: isLoading
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                if (groupNameController.text.isEmpty) {
                  !_key.currentState!.validate();
                } else {
                  createGroup();
                }
              },
              child: const Icon(Icons.check),
            ),
    );
  }

  createGroup() async {
    try {
      setState(() {
        isLoading = true;
      });
      profileUrl =
          await ImageController.uploadImageOnDb("profile_image", pickedFile);

      if (profileUrl.isNotEmpty) {
        await database
            .ref("users/${auth.currentUser!.uid}")
            .update({"ProfileImage": profileUrl});
      }
      List userIdList = widget.groupMemberList.map((e) => e.userId).toList();
      Map<String, dynamic> bodyData = {
        "groupName": groupNameController.text,
        "users": userIdList,
        "groupAdmin": [auth.currentUser!.uid],
        "createdOn": DateTime.now().toIso8601String(),
        "groupImage": profileUrl
      };

      await database
          .ref("ChatRooms/")
          .push()
          .child("Members/")
          .set(bodyData)
          .then((value) async {
        var getChatRoom = await database.ref("ChatRooms/").get();

        var getMyChatRoomId =
            getChatRoom.children.map((e) => e.key.toString()).toList().last;

        var getUsers = await database.ref("users").get();
        var getUserKey =
            getUsers.children.map((e) => e.key.toString()).toList();

        var getTargetUserList =
            widget.groupMemberList.map((e) => e.userId).toList();

        for (var targetKey in getTargetUserList) {
          var finalUserId =
              getUserKey.firstWhere((element) => element == targetKey);

          await database
              .ref("users/$finalUserId/Mychatrooms/Group/$getMyChatRoomId/")
              .set({"ChatId": getMyChatRoomId});
        }

        setState(() {
          isLoading = false;
        });

        AppServices.pushTo(
            context,
            GroupChatRoomScreen(
              groupName: groupNameController.text,
              groupId: getMyChatRoomId,
            ));
      });
    } catch (e) {
      print("E Checker :: ${e.toString()}");
      setState(() {
        isLoading = false;
      });
    }
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
                      pickedFile = await ImageController.pickImageWithCamera();
                      Navigator.of(context).pop(pickedFile);
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

                      Navigator.of(context).pop(pickedFile);
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
