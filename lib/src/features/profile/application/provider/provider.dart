import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/core/application/providers/firebase_providers.dart';
import 'package:redditx/src/core/infrastructure/object_storage_repository.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';
import 'package:redditx/src/features/profile/application/controller/controller.dart';
import 'package:redditx/src/features/profile/infrastructure/repository/user_profile_repository.dart';
import 'package:redditx/src/features/profile/infrastructure/service/user_profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
IUserProfileRepository iUserProfileRepository(IUserProfileRepositoryRef ref) =>
    throw UnimplementedError();

@riverpod
HttpUserProfileRepository httpUserProfileRepository(
        HttpUserProfileRepositoryRef ref) =>
    HttpUserProfileRepository(
        firebaseFirestore: ref.watch(firebaseFireStoreProvider));

@riverpod
UserProfileService userProfileService(UserProfileServiceRef ref) =>
    UserProfileService(
        iUserProfileRepository: ref.watch(iUserProfileRepositoryProvider),
        iObjectStorageRepository: ref.watch(iObjectStorageRepositoryProvider));

final getUserPostsProvider =
    StreamProvider.autoDispose.family<List<PostModel>, String>((ref, uid) {
  return ref.watch(userProfileControllerProvider.notifier).getPosts(uid: uid);
});
