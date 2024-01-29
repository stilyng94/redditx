import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/core/application/providers/firebase_providers.dart';
import 'package:redditx/src/core/infrastructure/object_storage_repository.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/features/post/application/controller/controller.dart';
import 'package:redditx/src/features/post/application/model/comment_model.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';
import 'package:redditx/src/features/post/infrastructure/repository/post_repository.dart';
import 'package:redditx/src/features/post/infrastructure/service/post_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
IPostRepository iPostRepository(IPostRepositoryRef ref) {
  throw UnimplementedError();
}

@riverpod
HttpPostRepository httpPostRepository(HttpPostRepositoryRef ref) =>
    HttpPostRepository(firebaseFirestore: ref.watch(firebaseFireStoreProvider));

@riverpod
PostService postService(PostServiceRef ref) => PostService(
    iPostRepository: ref.watch(iPostRepositoryProvider),
    iObjectStorageRepository: ref.watch(iObjectStorageRepositoryProvider));

final getPostsProvider = StreamProvider.autoDispose
    .family<List<PostModel>, List<CommunityModel>>((ref, communities) {
  return ref
      .watch(postControllerProvider.notifier)
      .getPosts(communities: communities);
});

final getPostByIdProvider =
    StreamProvider.autoDispose.family<PostModel, String>((ref, id) {
  return ref.watch(postControllerProvider.notifier).getPostById(id: id);
});

final getCommentsProvider = StreamProvider.autoDispose
    .family<List<CommentModel>, String>((ref, postId) {
  return ref.watch(postControllerProvider.notifier).getComments(postId: postId);
});

@riverpod
int currentPostIndex(CurrentPostIndexRef ref) => throw UnimplementedError();

@riverpod
int commentIndex(CommentIndexRef ref) => throw UnimplementedError();

@riverpod
String currentPostId(CurrentPostIdRef ref) => throw UnimplementedError();

final getGuestPostsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(postControllerProvider.notifier).getGuestPosts();
});
