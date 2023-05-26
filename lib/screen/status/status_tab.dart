// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/components/Loader/button_loader.dart';
import 'package:whatsapp_clone/controller/get_firebase_ref.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import 'package:whatsapp_clone/helper/base_getters.dart';
import 'package:whatsapp_clone/model/status_model.dart';
import 'package:whatsapp_clone/screen/status/status_view.dart';
import '../../controller/image_controller.dart';
import '../../helper/global_function.dart';
import '../../helper/styles/app_style_sheet.dart';
import '../../components/image_preview.dart';
import 'my_all_status.dart';

class StatusTabScreen extends StatefulWidget {
  const StatusTabScreen({super.key});

  @override
  State<StatusTabScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusTabScreen> {
  bool myStatus = false;
  List<StatusModel> getImage = [];
  @override
  void initState() {
    initialState();
    super.initState();
  }

  Future initialState() async {
    var getStatus = await GetFirebaseRef.getMyStatus().get();

    getImage = getStatus.children
        .map((e) => StatusModel.fromJson(
            e.value as Map<Object?, Object?>, e.key.toString()))
        .toList();

    if (getStatus.exists) {
      setState(() {
        myStatus = true;
      });
    } else {
      setState(() {
        myStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context).userModel;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            InkWell(
              onTap: () => getImage.isEmpty
                  ? updateStatus()
                  : AppServices.pushTo(
                      context,
                      StatusViewScreen(
                        statusModel: getImage,
                      )),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                              border: myStatus
                                  ? Border.all(
                                      color: AppColors.lightGreenColor,
                                      width: 2)
                                  : Border.all(),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(provider.profileImage),
                                  fit: BoxFit.cover)),
                        ),
                        myStatus
                            ? const SizedBox()
                            : Positioned(
                                right: 10,
                                child: Container(
                                  height: 22,
                                  width: 22,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryColor),
                                  child: const Icon(
                                    Icons.add,
                                    size: 18,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Status",
                          style: GetTextTheme.sf16_medium,
                        ),
                        AppServices.addHeight(2),
                        Text(
                          myStatus
                              ? "View your status"
                              : "Tap to add status update",
                          style: GetTextTheme.sf14_regular
                              .copyWith(color: AppColors.greyColor),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Center(
                        child: IconButton(
                      onPressed: () => AppServices.pushTo(
                          context,
                          MyAllStatus(
                            statusModel: getImage,
                          )),
                      icon: const Icon(
                        Icons.more_vert,
                      ),
                    ))
                  ],
                ),
              ),
            ),
            AppServices.addHeight(20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Updates",
              ),
            ),
            AppServices.addHeight(10),
            FirebaseAnimatedList(
              defaultChild: const ButtonLoader(),
              shrinkWrap: true,
              query: GetFirebaseRef.getAllStatus(),
              itemBuilder: ((context, snapshot, animation, index) {
                var getStatus = snapshot.value as Map<Object?, Object?>;
                return snapshot.key == auth.currentUser!.uid
                    ? const SizedBox()
                    : ListTile(
                        title: Text(getStatus["Name"].toString()),
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      getStatus["Image"].toString()),
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle,
                              color: AppColors.greyColor),
                        ),
                        subtitle: Text(
                          getStatus["CreatedAt"].toString(),
                          style: GetTextTheme.sf12_regular,
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          child: const Icon(Icons.camera_alt),
          onPressed: () => updateStatus()),
    );
  }

  Future updateStatus() async {
    List<PickedFile> getImage = await ImageController.multiImagePicker();

    if (getImage.isNotEmpty) {
      AppServices.pushTo(context, ImagePreviewScreen(imageFile: getImage));
    }
  }
}
