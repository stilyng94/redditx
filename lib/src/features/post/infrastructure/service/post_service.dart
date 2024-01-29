import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/core/infrastructure/object_storage_repository.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/features/post/application/model/comment_model.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';
import 'package:redditx/src/features/post/infrastructure/repository/post_repository.dart';

class PostService {
  final IPostRepository _iPostRepository;
  final IObjectStorageRepository _iObjectStorageRepository;

  PostService(
      {required IPostRepository iPostRepository,
      required IObjectStorageRepository iObjectStorageRepository})
      : _iPostRepository = iPostRepository,
        _iObjectStorageRepository = iObjectStorageRepository;

  TaskEither<String, Unit> addPost({required BasePostModel basePostModel}) {
    return _iPostRepository.addPost(basePostModel: basePostModel);
  }

  TaskEither<String, Unit> addPostWithObject({
    required BasePostModel basePostModel,
    required Uint8List objectBytes,
  }) {
    return TaskEither(() async {
      String error = '';
      BasePostModel model = basePostModel.copyBaseWith();

      final res = await _iObjectStorageRepository
          .storeObject(
              path: 'posts/${basePostModel.communityName}',
              id: basePostModel.communityName,
              bytes: objectBytes)
          .run();

      res.fold((l) {
        error = l.toString();
      }, (r) {
        model = model.copyBaseWith(link: r);
      });

      if (error.isNotEmpty) {
        return left(error);
      }
      return _iPostRepository.addPost(basePostModel: model).run();
    });
  }

  Stream<List<PostModel>> getPosts(
      {required List<CommunityModel> communities}) {
    return _iPostRepository.getPosts(communities: communities);
  }

  TaskEither<String, Unit> deletePost({required PostModel postModel}) {
    return _iPostRepository.deletePost(postModel: postModel);
  }

  TaskEither<String, Unit> upVotePost(
      {required PostModel postModel, required String userId}) {
    return _iPostRepository.upVotePost(postModel: postModel, userId: userId);
  }

  TaskEither<String, Unit> downVotePost(
      {required PostModel postModel, required String userId}) {
    return _iPostRepository.downVotePost(postModel: postModel, userId: userId);
  }

  Stream<PostModel> getPostById({required String id}) {
    return _iPostRepository.getPostById(id: id);
  }

  TaskEither<String, Unit> addComment({required CommentModel commentModel}) {
    return _iPostRepository.addComment(commentModel: commentModel);
  }

  Stream<List<CommentModel>> getComments({required String postId}) {
    return _iPostRepository.getComments(postId: postId);
  }

  TaskEither<String, Unit> awardPost(
      {required PostModel postModel,
      required String award,
      required String senderId}) {
    return _iPostRepository.awardPost(
        postModel: postModel, award: award, senderId: senderId);
  }

  Stream<List<PostModel>> getGuestPosts() {
    return _iPostRepository.getGuestPosts();
  }
}
