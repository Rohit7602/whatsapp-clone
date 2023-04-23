class UserModel {
  String userId;
  String name;
  String description;
  String profileImage;
  String number;
  String status;
  DateTime userCreatedOn;

  UserModel(this.userId, this.name, this.description, this.profileImage,
      this.number, this.status, this.userCreatedOn);

  UserModel.fromJson(Map<Object?, Object?> json, this.userId)
      : name = json["Name"].toString(),
        description = json["Description"].toString(),
        profileImage = json["ProfileImage"].toString(),
        number = json["Number"].toString(),
        status = json["Status"].toString(),
        userCreatedOn = DateTime.parse(json["CreatedOn"].toString());
}

// class TargetChatRoomId {
//   String chatId;

//   TargetChatRoomId(this.chatId);

//   TargetChatRoomId.fromJson(Map<Object?, Object?> json)
//       : chatId = json["ChatId"].toString();
// }



// class DataModel {
//   String userId;
//   String name;
//   String description;
//   String profileImage;
//   String number;
//   String status;
//   DateTime userCreatedOn;
//   DataModel(this.userId, this.name, this.description, this.profileImage,
//       this.number, this.status, this.userCreatedOn);

//   DataModel.fromJson(Map<Object?, Object?> json, this.userId)
//       : name = json["Name"].toString(),
//         description = json["Description"].toString(),
//         profileImage = json["ProfileImage"].toString(),
//         number = json["Number"].toString(),
//         status = json["Status"].toString(),
//         userCreatedOn = DateTime.parse(json["CreatedOn"].toString());
// }
