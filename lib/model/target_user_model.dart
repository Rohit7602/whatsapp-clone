import 'package:whatsapp_clone/model/user_model.dart';

import 'message_model.dart';

class TargetUserModel {
  String messageId;
  MessageModel messageModel;
  UserModel userModel;

  TargetUserModel(
    this.messageId,
    this.messageModel,
    this.userModel,
  );

  TargetUserModel.fromJson(this.messageId, this.messageModel, this.userModel);
}
