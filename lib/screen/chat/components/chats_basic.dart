import 'package:flutter/cupertino.dart';
import 'package:whatsapp_clone/helper/global_function.dart';

MainAxisAlignment messageAlignment(senderId) {
  return senderId == auth.currentUser!.uid
      ? MainAxisAlignment.end
      : MainAxisAlignment.start;
}

bool isSendIdOrCurrentIdTrue(senderId) {
  return senderId == auth.currentUser!.uid;
}

BorderRadius isMessageCircular() {
  return BorderRadius.circular(10);
}
