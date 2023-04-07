import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/function/custom_appbar.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';

import '../../getter_setter/getter_setter.dart';
import '../../helper/styles/app_style_sheet.dart';
import '../../model/user_model.dart';
import 'create_group.dart';

class AddMembersGroupScreen extends StatefulWidget {
  const AddMembersGroupScreen({super.key});

  @override
  State<AddMembersGroupScreen> createState() => _AddMembersGroupScreenState();
}

class _AddMembersGroupScreenState extends State<AddMembersGroupScreen> {
  List<UserModel> groupUser = [];

  @override
  void initState() {
    groupUser = [];
    var provider = Provider.of<GetterSetterModel>(context, listen: false);
    groupUser.add(provider.userModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);
    var userList = provider.getAllUser;

    return Scaffold(
      appBar: customAppBar(
        color: AppColors.primaryColor,
        title: Text("Add Members", style: GetTextTheme.sf18_medium),
        action: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppServices.addHeight(20),
            groupUser.isEmpty
                ? const Text("Add Members to create group.")
                : SizedBox(
                    height: 90,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: groupUser.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 7),
                                        height: 60,
                                        width: 60,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.lightGreyColor),
                                        child: groupUser[index].profileImage ==
                                                ""
                                            ? const Icon(
                                                Icons.person,
                                                color: AppColors.whiteColor,
                                                size: 40,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  groupUser[index].profileImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                      // groupUser[index].number ==
                                      //         provider.userModel.number
                                      //     ? const SizedBox()
                                      //     :

                                      Positioned(
                                        right: 8,
                                        bottom: 3,
                                        child: InkWell(
                                          onTap: () => index == 0
                                              ? null
                                              : setState(() {
                                                  groupUser
                                                      .remove(groupUser[index]);
                                                }),
                                          child: Container(
                                            height: 18,
                                            width: 18,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: index == 0
                                                    ? AppColors.blueColor
                                                    : AppColors.primaryColor),
                                            child: Icon(
                                              index == 0
                                                  ? Icons.verified
                                                  : Icons.close,
                                              color: AppColors.whiteColor,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  AppServices.addHeight(10),
                                  Text(
                                    groupUser[index].name,
                                    style: GetTextTheme.sf10_regular,
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                  ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(),
            ),
            userList.isEmpty
                ? const Text("You Don't have any contacts")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          var userChecker = groupUser.any((element) =>
                              element.number == userList[index].number);
                          if (userChecker == false) {
                            setState(() {
                              groupUser.add(userList[index]);
                            });
                          }
                        },
                        leading: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.lightGreyColor),
                              child: userList[index].profileImage == ""
                                  ? const Icon(
                                      Icons.person,
                                      color: AppColors.whiteColor,
                                      size: 40,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        userList[index].profileImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            groupUser.any((element) =>
                                    element.number == userList[index].number)
                                ? Container(
                                    height: 18,
                                    width: 18,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryColor),
                                    child: const Icon(
                                      Icons.check,
                                      color: AppColors.whiteColor,
                                      size: 15,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                        title: Text(
                          userList[index].number,
                          style: GetTextTheme.sf14_regular,
                        ),
                        subtitle: Text(
                          userList[index].userId,
                          // userList[index].description,
                          style: GetTextTheme.sf12_medium
                              .copyWith(color: AppColors.greyColor),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: groupUser.length >= 3
          ? FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () => AppServices.pushTo(
                  context,
                  CreateGroupScreen(
                    groupMemberList: groupUser,
                  )),
              child: const Icon(Icons.arrow_forward))
          : const SizedBox(),
    );
  }
}
