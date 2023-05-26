class StatusModel {
  String id;

  String image;
  String createdAt;

  StatusModel(this.id, this.image, this.createdAt);

  StatusModel.fromJson(Map<Object?, Object?> json, this.id)
      : image = json["Image"].toString(),
        createdAt = json["CreatedAt"].toString();
}
