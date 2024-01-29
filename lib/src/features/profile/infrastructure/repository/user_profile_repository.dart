import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/core/application/enums.dart';
import 'package:redditx/src/features/auth/application/model/user_model.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';

abstract class IUserProfileRepository {
  TaskEither<String, Unit> editProfile({required UserModel user});
  Stream<List<PostModel>> getPosts({required String uid});
  TaskEither<String, Unit> updateKarma({required UserModel user});
}

class HttpUserProfileRepository implements IUserProfileRepository {
  final FirebaseFirestore _firebaseFirestore;
  HttpUserProfileRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _usersCollection =>
      _firebaseFirestore.collection('users');

  CollectionReference get _postsCollection =>
      _firebaseFirestore.collection('posts');

  @override
  TaskEither<String, Unit> editProfile({required UserModel user}) {
    return TaskEither.tryCatch(() async {
      await _usersCollection.doc(user.uid).update(user.toMap());
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  Stream<List<PostModel>> getPosts({required String uid}) {
    return _postsCollection
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  TaskEither<String, Unit> updateKarma({required UserModel user}) {
    return TaskEither.tryCatch(() async {
      await _usersCollection.doc(user.uid).update({'karma': user.karma});
      return unit;
    }, (error, stackTrace) => error.toString());
  }
}
