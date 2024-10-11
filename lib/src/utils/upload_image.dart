import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadImage(File image) async {
  if (kDebugMode) {
    print(image.path);
  }

  // Generar un nombre único para el archivo
  String uniqueFileName = '${const Uuid().v4()}.jpg';

  final Reference ref = storage.ref().child("images").child(uniqueFileName);
  final UploadTask uploadTask = ref.putFile(image);
  if (kDebugMode) {
    print(uploadTask);
  }
  final TaskSnapshot snapshot =
      // ignore: avoid_print
      await uploadTask.whenComplete(() => print('upload complete'));
  if (kDebugMode) {
    print(snapshot);
  }
  final String url = await snapshot.ref.getDownloadURL();
  if (kDebugMode) {
    print(url);
  }
  if (snapshot.state == TaskState.success) {
    return url;
  } else {
    return url;
  }
}
