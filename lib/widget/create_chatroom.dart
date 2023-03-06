String createChatRoomId(String user1, String user2) {
  if (user1[0].toLowerCase().codeUnits[0] ==
      user2[0].toLowerCase().codeUnits[0]) {
    return "${"${user1}1"}_vs_$user2";
  } else if (user1[0].toLowerCase().codeUnits[0] >
      user2[0].toLowerCase().codeUnits[0]) {
    return "${user1}_vs_$user2";
  } else {
    return "${user2}_vs_$user1";
  }
}


  // String createChatRoomId(String user1, String user2) {
  //   if ((user1 == user2) == true) {
  //     if (user1[0].toLowerCase().codeUnits[0] >
  //         user2.toLowerCase().codeUnits[0]) {
  //       return "${"${user1}1"}_vs_$user2";
  //     } else {
  //       return "${user2}_vs_${"${user1}1"}";
  //     }
  //   } else {
  //     if (user1[0].toLowerCase().codeUnits[0] >
  //         user2.toLowerCase().codeUnits[0]) {
  //       return "${user1}_vs_$user2";
  //     } else {
  //       return "${user2}_vs_$user1";
  //     }
  //   }
  // }