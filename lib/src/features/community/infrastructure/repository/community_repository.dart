import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';

abstract class ICommunityRepository {
  TaskEither<String, Unit> createCommunity(
      {required CommunityModel communityModel});
  Stream<List<CommunityModel>> getUserCommunities({required String uid});
  Stream<CommunityModel> getCommunity({required String name});
  TaskEither<String, Unit> editCommunity(
      {required CommunityModel communityModel});
  Stream<List<CommunityModel>> searchCommunity({required String query});
  TaskEither<String, Unit> joinCommunity(
      {required String userId, required String communityName});
  TaskEither<String, Unit> leaveCommunity(
      {required String userId, required String communityName});
  TaskEither<String, Unit> addMods(
      {required List<String> ids, required String communityName});
  Stream<List<PostModel>> getCommunityPosts({required String name});
}

class HttpCommunityRepository implements ICommunityRepository {
  final FirebaseFirestore _firebaseFirestore;

  HttpCommunityRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _communitiesReference =>
      _firebaseFirestore.collection('communities');
  CollectionReference get _postsReference =>
      _firebaseFirestore.collection('posts');

  @override
  TaskEither<String, Unit> createCommunity(
      {required CommunityModel communityModel}) {
    return TaskEither
            .tryCatch(
                () async =>
                    await _communitiesReference.doc(communityModel.name).get(),
                (error, stackTrace) => error.toString())
        .flatMap((r) =>
            TaskEither<String, DocumentSnapshot<Object?>>.fromPredicate(
                r, (r) => !r.exists, (_) => 'error'))
        .flatMap((r) => TaskEither.tryCatch(() async {
              await _communitiesReference
                  .doc(communityModel.name)
                  .set(communityModel.toMap());
              return unit;
            }, (o, s) => o.toString()));
  }

  @override
  Stream<List<CommunityModel>> getUserCommunities({required String uid}) {
    return _communitiesReference
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) => event.docs
            .map(
                (e) => CommunityModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Stream<List<CommunityModel>> searchCommunity({required String query}) {
    final trimmed = query.trim();
    return _communitiesReference
        .where('name',
            isGreaterThanOrEqualTo: trimmed.isEmpty ? 0 : trimmed,
            isLessThan: trimmed.isEmpty
                ? null
                : trimmed.substring(0, trimmed.length - 1) +
                    String.fromCharCode(
                        trimmed.codeUnitAt(trimmed.length - 1) + 1))
        .snapshots()
        .map((event) => event.docs
            .map(
                (e) => CommunityModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Stream<CommunityModel> getCommunity({required String name}) {
    return _communitiesReference.doc(name).snapshots().map((event) =>
        CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  @override
  TaskEither<String, Unit> editCommunity(
      {required CommunityModel communityModel}) {
    return TaskEither.tryCatch(() async {
      await _communitiesReference
          .doc(communityModel.name)
          .update(communityModel.toMap());
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, Unit> joinCommunity(
      {required String userId, required String communityName}) {
    return TaskEither.tryCatch(() async {
      await _communitiesReference.doc(communityName).update({
        'members': FieldValue.arrayUnion([userId])
      });
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, Unit> leaveCommunity(
      {required String userId, required String communityName}) {
    return TaskEither.tryCatch(() async {
      await _communitiesReference.doc(communityName).update({
        'members': FieldValue.arrayRemove([userId])
      });
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, Unit> addMods(
      {required List<String> ids, required String communityName}) {
    return TaskEither.tryCatch(() async {
      await _communitiesReference.doc(communityName).update({'mods': ids});
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  Stream<List<PostModel>> getCommunityPosts({required String name}) {
    return _postsReference
        .where('communityName', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }
}
