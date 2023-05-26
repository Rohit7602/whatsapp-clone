// ignore_for_file: non_constant_identifier_names, must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/controller/image_controller.dart';
import '../components/upload_image_db.dart';

class ImagePickerFunction extends StatelessWidget {
  const ImagePickerFunction({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () async {
              await ImageController. pickImageWithCamera().then((value) {
                Navigator.of(context).pop(value);
              });
            },
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
          ),
          const Divider(),
          ListTile(
            onTap: () async {
              await ImageController.pickImageWithGallery().then((value) {
                Navigator.of(context).pop(value);
              });
            },
            leading: const Icon(Icons.image),
            title: const Text("Gallery"),
          ),
        ],
      ),
    );
  }
}
