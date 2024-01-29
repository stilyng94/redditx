import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/core/application/providers/firebase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'object_storage_repository.g.dart';

abstract class IObjectStorageRepository {
  TaskEither<Unit, String> storeObject(
      {required String path, required String id, required Uint8List bytes});
}

class ObjectStorageRepositoryWithFirebaseStorage
    implements IObjectStorageRepository {
  final FirebaseStorage _firebaseStorage;

  ObjectStorageRepositoryWithFirebaseStorage(
      {required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  @override
  TaskEither<Unit, String> storeObject(
      {required String path, required String id, required Uint8List bytes}) {
    return TaskEither.tryCatch(() async {
      final snapshot =
          await _firebaseStorage.ref().child(path).child(id).putData(bytes);
      final url = await snapshot.ref.getDownloadURL();
      return url;
    }, (error, stackTrace) => unit);
  }
}

@riverpod
IObjectStorageRepository iObjectStorageRepository(
        IObjectStorageRepositoryRef ref) =>
    throw UnimplementedError();

@riverpod
ObjectStorageRepositoryWithFirebaseStorage
    objectStorageRepositoryWithFirebaseStorage(
            ObjectStorageRepositoryWithFirebaseStorageRef ref) =>
        ObjectStorageRepositoryWithFirebaseStorage(
            firebaseStorage: ref.watch(firebaseStorageProvider));
