// ignore_for_file: invalid_use_of_visible_for_testing_member, avoid_print

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageController {
  static Future uploadImageOnDb(fileName, File? pickedFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      var getImageUrl = await storage
          .ref()
          .child("$fileName/${DateTime.now().microsecondsSinceEpoch}.jpg")
          .putFile(File(pickedFile!.path));

      return await getImageUrl.ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
    }
  }

  static Future pickImageWithGallery() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    return File(image!.path);
  }

  static Future multiImagePicker() async {
    List<PickedFile> fileImage = [];
    var image = await ImagePicker.platform.pickMultiImage();
    fileImage.addAll(image!);
    return fileImage;
  }

  static Future pickImageWithCamera() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    return File(image!.path);
  }
}
