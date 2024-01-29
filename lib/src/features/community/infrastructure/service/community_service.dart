import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/core/infrastructure/object_storage_repository.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/features/community/infrastructure/repository/community_repository.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';

class CommunityService {
  final ICommunityRepository _iCommunityRepository;
  final IObjectStorageRepository _iObjectStorageRepository;

  CommunityService(
      {required ICommunityRepository communityRepository,
      required IObjectStorageRepository iObjectStorageRepository})
      : _iCommunityRepository = communityRepository,
        _iObjectStorageRepository = iObjectStorageRepository;

  TaskEither<String, Unit> createCommunity(
      {required CommunityModel communityModel}) {
    return _iCommunityRepository.createCommunity(
        communityModel: communityModel);
  }

  Stream<List<CommunityModel>> getUserCommunities({required String uid}) {
    return _iCommunityRepository.getUserCommunities(uid: uid);
  }

  Stream<List<CommunityModel>> searchCommunity({required String query}) {
    return _iCommunityRepository.searchCommunity(query: query);
  }

  Stream<CommunityModel> getCommunity({required String name}) {
    return _iCommunityRepository.getCommunity(name: name);
  }

  TaskEither<String, Unit> editCommunity(
      {required CommunityModel communityModel,
      Uint8List? bannerFileBytes,
      Uint8List? profileFileBytes}) {
    return TaskEither(() async {
      String error = '';
      CommunityModel model = communityModel.copyWith();

      if (bannerFileBytes != null) {
        final res = TaskEither(() => _iObjectStorageRepository
            .storeObject(
                path: 'communities/banner',
                id: communityModel.name,
                bytes: bannerFileBytes)
            .run());
        res.match((l) {
          error = l.toString();
        }, (r) {
          model = model.copyWith(banner: r);
        });
        if (error.isNotEmpty) {
          return left('left');
        }
      }
      if (profileFileBytes != null) {
        final res = TaskEither(() => _iObjectStorageRepository
            .storeObject(
                path: 'communities/banner',
                id: communityModel.name,
                bytes: profileFileBytes)
            .run());
        res.match((l) {
          error = l.toString();
        }, (r) {
          model = model.copyWith(avatarUrl: r);
        });
        if (error.isNotEmpty) {
          return left('left');
        }
      }
      return _iCommunityRepository.editCommunity(communityModel: model).run();
    });
  }

  TaskEither<String, Unit> joinCommunity(
      {required String userId, required String communityName}) {
    return _iCommunityRepository.joinCommunity(
        userId: userId, communityName: communityName);
  }

  TaskEither<String, Unit> leaveCommunity(
      {required String userId, required String communityName}) {
    return _iCommunityRepository.leaveCommunity(
        userId: userId, communityName: communityName);
  }

  TaskEither<String, Unit> addMods(
      {required List<String> ids, required String communityName}) {
    return _iCommunityRepository.addMods(
        ids: ids, communityName: communityName);
  }

  Stream<List<PostModel>> getCommunityPosts({required String name}) {
    return _iCommunityRepository.getCommunityPosts(name: name);
  }
}
