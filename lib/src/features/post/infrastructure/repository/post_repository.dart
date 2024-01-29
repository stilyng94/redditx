import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/features/post/application/model/comment_model.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';

abstract class IPostRepository {
  TaskEither<String, Unit> addPost({required BasePostModel basePostModel});
  Stream<List<PostModel>> getPosts({required List<CommunityModel> communities});
  TaskEither<String, Unit> deletePost({required PostModel postModel});
  TaskEither<String, Unit> upVotePost(
      {required PostModel postModel, required String userId});
  TaskEither<String, Unit> downVotePost(
      {required PostModel postModel, required String userId});
  Stream<PostModel> getPostById({required String id});
  TaskEither<String, Unit> addComment({required CommentModel commentModel});
  Stream<List<CommentModel>> getComments({required String postId});
  TaskEither<String, Unit> awardPost(
      {required PostModel postModel,
      required String award,
      required String senderId});
  Stream<List<PostModel>> getGuestPosts();
}

class HttpPostRepository implements IPostRepository {
  final FirebaseFirestore _firebaseFirestore;

  HttpPostRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _postsRef => _firebaseFirestore.collection('posts');
  CollectionReference get _commentsRef =>
      _firebaseFirestore.collection('comments').withConverter<CommentModel>(
          fromFirestore: (snapshot, _) =>
              CommentModel.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap());
  CollectionReference get _usersRef => _firebaseFirestore.collection('users');

  @override
  TaskEither<String, Unit> addPost({required BasePostModel basePostModel}) {
    return TaskEither.tryCatch(() async {
      await _postsRef.doc(basePostModel.id).set(basePostModel.baseToMap());
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  Stream<List<PostModel>> getPosts(
      {required List<CommunityModel> communities}) {
    return _postsRef
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  TaskEither<String, Unit> deletePost({required PostModel postModel}) {
    return TaskEither.tryCatch(() async {
      await _postsRef.doc(postModel.id).delete();
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, Unit> upVotePost(
      {required PostModel postModel, required String userId}) {
    return TaskEither.tryCatch(() async {
      if (postModel.downVotes.contains(userId)) {
        await _postsRef.doc(postModel.id).update({
          'downVotes': FieldValue.arrayRemove([userId])
        });
      }

      if (postModel.upVotes.contains(userId)) {
        await _postsRef.doc(postModel.id).update({
          'upVotes': FieldValue.arrayRemove([userId])
        });
      } else {
        await _postsRef.doc(postModel.id).update({
          'upVotes': FieldValue.arrayUnion([userId])
        });
      }
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, Unit> downVotePost(
      {required PostModel postModel, required String userId}) {
    return TaskEither.tryCatch(() async {
      if (postModel.upVotes.contains(userId)) {
        await _postsRef.doc(postModel.id).update({
          'upVotes': FieldValue.arrayRemove([userId])
        });
      }

      if (postModel.downVotes.contains(userId)) {
        await _postsRef.doc(postModel.id).update({
          'downVotes': FieldValue.arrayRemove([userId])
        });
      } else {
        await _postsRef.doc(postModel.id).update({
          'downVotes': FieldValue.arrayUnion([userId])
        });
      }
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  Stream<PostModel> getPostById({required String id}) {
    return _postsRef.doc(id).snapshots().map(
        (event) => PostModel.fromMap(event.data() as Map<String, dynamic>));
  }

  @override
  TaskEither<String, Unit> addComment({required CommentModel commentModel}) {
    return TaskEither.tryCatch(() async {
      await _commentsRef.add(commentModel);
      await _postsRef
          .doc(commentModel.postId)
          .update({'commentCount': FieldValue.increment(1)});
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  Stream<List<CommentModel>> getComments({required String postId}) {
    return _commentsRef
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => e.data() as CommentModel).toList());
  }

  @override
  TaskEither<String, Unit> awardPost(
      {required PostModel postModel,
      required String award,
      required String senderId}) {
    return TaskEither.tryCatch(() async {
      await _firebaseFirestore.runTransaction((transaction) async {
        return transaction.update(_postsRef.doc(postModel.id), {
          'awards': FieldValue.arrayUnion([award])
        }).update(_usersRef.doc(senderId), {
          'awards': FieldValue.arrayRemove([award])
        }).update(_usersRef.doc(postModel.uid), {
          'awards': FieldValue.arrayUnion([award])
        });
      });

      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  Stream<List<PostModel>> getGuestPosts() {
    return _postsRef
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }
}
