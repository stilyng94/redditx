import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/core/infrastructure/object_storage_repository.dart';
import 'package:redditx/src/features/auth/application/model/user_model.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';
import 'package:redditx/src/features/profile/infrastructure/repository/user_profile_repository.dart';

class UserProfileService {
  final IUserProfileRepository _iUserProfileRepository;
  final IObjectStorageRepository _iObjectStorageRepository;

  UserProfileService(
      {required IUserProfileRepository iUserProfileRepository,
      required IObjectStorageRepository iObjectStorageRepository})
      : _iUserProfileRepository = iUserProfileRepository,
        _iObjectStorageRepository = iObjectStorageRepository;

  TaskEither<String, UserModel> editProfile({
    required UserModel user,
    required Uint8List? bannerFileBytes,
    required Uint8List? profileFileBytes,
    required String? name,
  }) {
    String error = '';
    if (bannerFileBytes != null) {
      final res = TaskEither(() => _iObjectStorageRepository
          .storeObject(
              path: 'users/banner', id: user.uid, bytes: bannerFileBytes)
          .run());
      res.match((l) {
        error = l.toString();
      }, (r) => user.copyWith(banner: r));
      if (error.isNotEmpty) {
        return TaskEither.left('left');
      }
    }
    if (profileFileBytes != null) {
      final res = TaskEither(() => _iObjectStorageRepository
          .storeObject(
              path: 'users/banner', id: user.uid, bytes: profileFileBytes)
          .run());
      res.match((l) {
        error = l.toString();
      }, (r) => user.copyWith(profilePic: r));
      if (error.isNotEmpty) {
        return TaskEither.left('left');
      }
    }
    user.copyWith(name: name);
    return TaskEither(() => _iUserProfileRepository
        .editProfile(user: user)
        .flatMap(
            (r) => TaskEither<String, UserModel>.fromEither(Either.right(user)))
        .run());
  }

  Stream<List<PostModel>> getPosts({required String uid}) {
    return _iUserProfileRepository.getPosts(uid: uid);
  }

  TaskEither<String, Unit> updateKarma({required UserModel user}) {
    return _iUserProfileRepository.updateKarma(user: user);
  }
}
