import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:whatsapp_clone/getter_setter/getter_setter.dart';
import '../../helper/base_getters.dart';
import '../../helper/styles/app_style_sheet.dart';
import '../../model/status_model.dart';

class StatusViewScreen extends StatefulWidget {
  List<StatusModel> statusModel;
  StatusViewScreen({required this.statusModel, super.key});

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  final StoryController storycontroller = StoryController();

  bool appBarHide = false;
  List<StoryItem> storyItems = [];

  storyItem() {
    StoryItem? storys;
    for (var element in widget.statusModel) {
      storys = StoryItem.pageImage(
          caption: "sdf",
          url: element.image.toString(),
          controller: storycontroller);
      storyItems.add(storys);
    }
  }

  @override
  void initState() {
    storyItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GetterSetterModel>(context);

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: GestureDetector(
          onLongPress: () {
            // setState(() {
            //   appBarHide = true;
            // });
          },
          onPanCancel: () {
            // setState(() {
            //   appBarHide = false;
            // });
          },
          child: Stack(
            children: [
              StoryView(
                  onComplete: () => AppServices.popView(context),
                  inline: true,
                  indicatorColor: AppColors.whiteColor,
                  storyItems: storyItems,
                  controller: storycontroller),
              Positioned(
                top: 30,
                child: appBarHide
                    ? const SizedBox()
                    : Row(
                        children: [
                          IconButton(
                              onPressed: () => AppServices.popView(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.whiteColor,
                              )),
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.greyColor,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        provider.userModel.profileImage),
                                    fit: BoxFit.cover)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "My Status",
                                style: GetTextTheme.sf18_medium
                                    .copyWith(color: AppColors.whiteColor),
                              ),
                              AppServices.addHeight(3),
                              Text(
                                "My Story",
                                style: GetTextTheme.sf12_regular.copyWith(
                                    color: AppColors.greyColor.shade300),
                              ),
                            ],
                          )
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
