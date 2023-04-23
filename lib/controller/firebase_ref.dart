import 'package:firebase_database/firebase_database.dart';
import 'package:whatsapp_clone/helper/global_function.dart';

class GetFirebaseRef {
  static Query getCurrentUser(String number) =>
      database.ref("Users").orderByChild("Number").equalTo(number);
}
