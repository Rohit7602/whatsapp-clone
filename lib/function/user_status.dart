import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../getter_setter/getter_setter.dart';
import '../../helper/global_function.dart';
import '../../model/user_model.dart';

void setUserStatus(BuildContext context, String status) async {
  var provider = Provider.of<GetterSetterModel>(context, listen: false);
  database.ref("users/${auth.currentUser!.uid}").update({
    "Status": status,
  });
  var userPath = await database.ref("users/${auth.currentUser!.uid}").get();
  var userModel = UserModel.fromJson(
      userPath.value as Map<Object?, Object?>, userPath.key.toString());
  provider.getUserModel(userModel);
}
