import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/core/application/providers/firebase_providers.dart';
import 'package:redditx/src/core/infrastructure/object_storage_repository.dart';
import 'package:redditx/src/features/community/application/controller/controller.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/features/community/infrastructure/repository/community_repository.dart';
import 'package:redditx/src/features/community/infrastructure/service/community_service.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
ICommunityRepository iCommunityRepository(ICommunityRepositoryRef ref) =>
    throw UnimplementedError();

@riverpod
HttpCommunityRepository httpCommunityRepository(
    HttpCommunityRepositoryRef ref) {
  return HttpCommunityRepository(
      firebaseFirestore: ref.watch(firebaseFireStoreProvider));
}

@riverpod
CommunityService communityService(CommunityServiceRef ref) => CommunityService(
    communityRepository: ref.watch(iCommunityRepositoryProvider),
    iObjectStorageRepository: ref.watch(iObjectStorageRepositoryProvider));

final getCommunityProvider =
    StreamProvider.family.autoDispose<CommunityModel, String>((ref, name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunity(name: name);
});

final getUserCommunitiesProvider = StreamProvider.autoDispose((ref) =>
    ref.watch(communityControllerProvider.notifier).getUserCommunities());

final searchCommunitiesProvider = StreamProvider.family
    .autoDispose<List<CommunityModel>, String>((ref, query) => ref
        .watch(communityControllerProvider.notifier)
        .searchCommunities(query: query));

final getCommunityPostsProvider = StreamProvider.family
    .autoDispose<List<PostModel>, String>((ref, name) => ref
        .watch(communityControllerProvider.notifier)
        .getCommunityPosts(name: name));

@riverpod
class ToggleModeratorStatus extends _$ToggleModeratorStatus {
  @override
  Set<String> build() {
    return <String>{};
  }
}

@riverpod
String currentMemberUid(CurrentMemberUidRef ref) => throw UnimplementedError();

@riverpod
int currentCommunityIndex(CurrentCommunityIndexRef ref) =>
    throw UnimplementedError();

@riverpod
String currentSearchQuery(CurrentSearchQueryRef ref) =>
    throw UnimplementedError();
