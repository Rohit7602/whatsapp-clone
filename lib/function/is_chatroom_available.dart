// ignore_for_file: avoid_print

import '../helper/global_function.dart';

Future<String> isChatRoomAvailable(String targetUser) async {
  var myChatRoomList =
      await database.ref("users/${auth.currentUser!.uid}/Mychatrooms/").get();
  var myChatID = myChatRoomList.children;
  if (myChatID.isNotEmpty) {
    var userChatID = myChatID.map((e) => e.key).toList();
    var targetChatRoomList =
        await database.ref("users/$targetUser/Mychatrooms/").get();

    var targetChatID =
        targetChatRoomList.children.map((e) => e.key.toString()).toList();
    print(targetChatID);
    print(userChatID);

    for (var myroom in userChatID) {
      print("My Room ID  $myroom");
      for (var targetroom in targetChatID) {
        print("@nd $myroom");
        print(targetUser);
        if (myroom == targetroom) {
          print("My Room Checker :::::: $myroom");
          return myroom!;
        } else {
          continue;
        }
      }
    }
  } else {
    return "";
  }
  return "";
}
