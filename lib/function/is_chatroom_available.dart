import '../helper/global_function.dart';

Future<String> isChatRoomAvailable(String targetUser) async {
  var myChatRoomList =
      await database.ref("users/${auth.currentUser!.uid}/Mychatrooms/").get();
  var myChatID = myChatRoomList.children;
  if (myChatID.isNotEmpty) {
    var userChatID = myChatID.map((e) => e.key).toList();
    var targetChatRoomList =
        await database.ref("users/$targetUser/Mychatrooms/").get();

    var targetChatID = targetChatRoomList.children.map((e) => e.key).toList();

    for (var myroom in userChatID) {
      for (var targetroom in targetChatID) {
        print(myroom);
        print("target$targetroom");
        if (myroom == targetroom) {
          return myroom!;
        } else {
          return "";
        }
      }
    }
  } else {
    return "";
  }
  return "";
}
