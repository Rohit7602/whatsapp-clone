import 'package:firebase_database/firebase_database.dart';
import 'package:whatsapp_clone/helper/global_function.dart';

class GetFirebaseRef {
  static Query getInitUser(String number) =>
      database.ref("users").orderByChild("Number").equalTo(number);
}
