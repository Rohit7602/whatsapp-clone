import 'package:flutter/material.dart';
import '../../helper/global_function.dart';

void setUserStatus(BuildContext context, String status) async { 
  database.ref("users/${auth.currentUser!.uid}").update({
    "Status": status,
  });
}
