// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

uploadImageOnDb(fileName, File? pickedFile) async {
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

Future pickImageWithGallery() async {
  var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
  return File(image!.path);
}

Future pickImageWithCamera() async {
  var image = await ImagePicker.platform.pickImage(source: ImageSource.camera);
  return File(image!.path);
}
