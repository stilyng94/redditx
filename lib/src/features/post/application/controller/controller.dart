import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/core/application/enums.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/features/post/application/model/comment_model.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';
import 'package:redditx/src/features/post/application/provider/provider.dart';
import 'package:redditx/src/features/profile/application/controller/controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'controller.g.dart';

@riverpod
class PostController extends _$PostController {
  @override
  ControllerState build() {
    return ControllerStateInitial();
  }

  Task<Unit> shareTextPost({
    required String title,
    required CommunityModel communityModel,
    required String description,
  }) {
    return Task(() async {
      state = ControllerStateLoading();
      final user = ref.read(userNotifierProvider)!;
      final post = BasePostModel(
          id: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          title: title,
          communityName: communityModel.name,
          username: user.name,
          description: description,
          uid: user.uid,
          postType: PostType.text.name,
          communityProfilePic: communityModel.avatarUrl,
          createdAt: DateTime.now().toUtc());
      final failureOrSuccess = await ref
          .read(postServiceProvider)
          .addPost(basePostModel: post)
          .run();
      await ref
          .read(userProfileControllerProvider.notifier)
          .updateKarma(karma: Karma.textPost)
          .run();
      state = failureOrSuccess.fold(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Task<Unit> shareLinkPost({
    required String title,
    required CommunityModel communityModel,
    required String link,
  }) {
    return Task(() async {
      state = ControllerStateLoading();
      final user = ref.read(userNotifierProvider)!;
      final post = BasePostModel(
          id: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          title: title,
          communityName: communityModel.name,
          communityProfilePic: communityModel.avatarUrl,
          username: user.name,
          uid: user.uid,
          link: link,
          postType: PostType.link.name,
          createdAt: DateTime.now().toUtc());
      final failureOrSuccess = await ref
          .read(postServiceProvider)
          .addPost(basePostModel: post)
          .run();
      await ref
          .read(userProfileControllerProvider.notifier)
          .updateKarma(karma: Karma.linkPost)
          .run();
      state = failureOrSuccess.fold(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Task<Unit> shareImagePost({
    required String title,
    required CommunityModel communityModel,
    required Uint8List objectBytes,
  }) {
    return Task(() async {
      state = ControllerStateLoading();
      final user = ref.read(userNotifierProvider)!;
      final post = BasePostModel(
          title: title,
          id: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          communityName: communityModel.name,
          username: user.name,
          uid: user.uid,
          communityProfilePic: communityModel.avatarUrl,
          postType: PostType.image.name,
          createdAt: DateTime.now().toUtc());
      final failureOrSuccess = await ref
          .read(postServiceProvider)
          .addPostWithObject(basePostModel: post, objectBytes: objectBytes)
          .run();
      await ref
          .read(userProfileControllerProvider.notifier)
          .updateKarma(karma: Karma.imagePost)
          .run();
      state = failureOrSuccess.fold(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Stream<List<PostModel>> getPosts(
      {required List<CommunityModel> communities}) {
    if (communities.isNotEmpty) {
      return ref.read(postServiceProvider).getPosts(communities: communities);
    }
    return Stream.value([]);
  }

  Task<Unit> deletePost({required PostModel postModel}) {
    return Task(() async {
      state = ControllerStateLoading();
      final failureOrSuccess = await ref
          .read(postServiceProvider)
          .deletePost(postModel: postModel)
          .run();
      await ref
          .read(userProfileControllerProvider.notifier)
          .updateKarma(karma: Karma.deletePost)
          .run();
      state = failureOrSuccess.fold(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Task<Unit> upVotePost({required PostModel postModel}) {
    return Task(() async {
      state = ControllerStateLoading();
      final user = ref.read(userNotifierProvider)!;
      final failureOrSuccess = await ref
          .read(postServiceProvider)
          .upVotePost(postModel: postModel, userId: user.uid)
          .run();
      state = failureOrSuccess.fold(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Task<Unit> downVotePost({required PostModel postModel}) {
    return Task(() async {
      state = ControllerStateLoading();
      final user = ref.read(userNotifierProvider)!;
      final failureOrSuccess = await ref
          .read(postServiceProvider)
          .downVotePost(postModel: postModel, userId: user.uid)
          .run();
      state = failureOrSuccess.fold(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Stream<PostModel> getPostById({required String id}) {
    return ref.read(postServiceProvider).getPostById(id: id);
  }

  Task<Unit> addComment({required String text, required String postId}) {
    return Task(() async {
      state = ControllerStateLoading();
      final user = ref.read(userNotifierProvider)!;

      final comment = CommentModel(
          id: DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
          text: text,
          createdAt: DateTime.now().toUtc(),
          postId: postId,
          username: user.name,
          profilePic: user.profilePic);

      final failureOrSuccess = await ref
          .read(postServiceProvider)
          .addComment(commentModel: comment)
          .run();

      await ref
          .read(userProfileControllerProvider.notifier)
          .updateKarma(karma: Karma.comment)
          .run();

      state = failureOrSuccess.fold(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Stream<List<CommentModel>> getComments({required String postId}) {
    return ref.read(postServiceProvider).getComments(postId: postId);
  }

  Task<Unit> awardPost(
      {required PostModel postModel,
      required String award,
      required String senderId}) {
    return Task(() async {
      state = ControllerStateLoading();
      final user = ref.read(userNotifierProvider)!;

      final failureOrSuccess = await ref
          .read(postServiceProvider)
          .awardPost(postModel: postModel, award: award, senderId: user.uid)
          .run();

      await ref
          .read(userProfileControllerProvider.notifier)
          .updateKarma(karma: Karma.awardPost)
          .run();

      final awards = user.awards;
      awards.remove(award);

      ref.read(userNotifierProvider.notifier).state =
          user.copyWith(awards: awards);

      state = failureOrSuccess.fold(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Stream<List<PostModel>> getGuestPosts() {
    return ref.read(postServiceProvider).getGuestPosts();
  }
}
