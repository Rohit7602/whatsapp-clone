import 'package:firebase_database/firebase_database.dart';
import 'package:whatsapp_clone/helper/global_function.dart';

class GetFirebaseRef {
  // Query to get User By Number
  static Query getInitUser(String number) =>
      database.ref("users").orderByChild("Number").equalTo(number);

  // function to get my Status
  static Query getMyStatus() => database.ref("Status/${auth.currentUser!.uid}");

  // function to get all Status
  static Query getAllStatus() => database.ref("Status");
}
