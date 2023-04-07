class GroupChatModel {
  String groupName;
  String groupId;
  DateTime createdOn;
  String groupImage;
  List<String> groupAdmin;
  List<String> groupUsers;

  GroupChatModel(this.groupName, this.groupId, this.createdOn, this.groupImage,
      this.groupAdmin, this.groupUsers);

  GroupChatModel.fromJson(Map<Object?, Object?> json, this.groupId)
      : groupName = json["groupName"].toString(),
        createdOn = DateTime.parse(json["createdOn"].toString()),
        groupImage = json["groupImage"].toString(),
        groupAdmin =
            (json["groupAdmin"] as List).map((e) => e.toString()).toList(),
        groupUsers = (json["users"] as List).map((e) => e.toString()).toList();
}
