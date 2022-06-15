import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    firebase_storage.TaskSnapshot uploaded_image =
        await storage.ref('petImages/$fileName').putFile(file);
    return 'petImages/$fileName';
  }
}
