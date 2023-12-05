import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:greendit/core/failure.dart';
import 'package:greendit/core/providers/firebase_provider.dart';
import 'package:greendit/core/type_def.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepositoty(
    firebaseStorage: ref.watch(storageProvider),
  ),
);

class StorageRepositoty {
  final FirebaseStorage _firebaseStorage;

  StorageRepositoty({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile(
      {required String path, required String Id, required File? file}) async {
    try {
      //user/banner/111
      final ref = _firebaseStorage.ref().child(path).child(path);

      UploadTask uploadTask = ref.putFile(file!);

      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
