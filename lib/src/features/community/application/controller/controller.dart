import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'controller.g.dart';

@riverpod
class CommunityController extends _$CommunityController {
  @override
  ControllerState build() {
    return ControllerStateInitial();
  }

  Task<Unit> createCommunity({required String name}) {
    return Task(() async {
      state = ControllerStateLoading();
      final uid = ref.read(userNotifierProvider.select((value) => value!.uid));

      final community = CommunityModel(
          id: name,
          name: name,
          banner: AssetsPath.bannerDefault,
          avatarUrl: AssetsPath.avatarDefault,
          members: [uid],
          mods: [uid]);

      final res = await ref
          .read(communityServiceProvider)
          .createCommunity(communityModel: community)
          .run();
      state = res.match(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Task<Unit> editCommunity({
    required CommunityModel community,
    Uint8List? bannerFileBytes,
    Uint8List? profileFileBytes,
  }) {
    return Task(() async {
      state = ControllerStateLoading();

      final res = await ref
          .read(communityServiceProvider)
          .editCommunity(
              communityModel: community,
              bannerFileBytes: bannerFileBytes,
              profileFileBytes: profileFileBytes)
          .run();
      state = res.match(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Task<Unit> joinOrLeaveCommunity(
      {required String communityName,
      required String userId,
      required bool isMember}) {
    state = ControllerStateLoading();
    Either<String, Unit> failureOrSuccess;
    return Task(() async {
      if (isMember) {
        //Remove
        failureOrSuccess = await ref
            .read(communityServiceProvider)
            .leaveCommunity(userId: userId, communityName: communityName)
            .run();
      } else {
        //Join
        failureOrSuccess = await ref
            .read(communityServiceProvider)
            .joinCommunity(userId: userId, communityName: communityName)
            .run();
      }
      state = failureOrSuccess.fold(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Task<Unit> addMods({required String communityName}) {
    return Task(() async {
      state = ControllerStateLoading();
      final res = await ref
          .read(communityServiceProvider)
          .addMods(
              communityName: communityName,
              ids: ref.read(toggleModeratorStatusProvider).toList())
          .run();
      state = res.match(
          (l) => ControllerStateFailure(l), (r) => ControllerStateSuccess());
      return unit;
    });
  }

  Stream<CommunityModel> getCommunity({required String name}) {
    return ref.read(communityServiceProvider).getCommunity(name: name);
  }

  Stream<List<CommunityModel>> getUserCommunities() =>
      ref.read(communityServiceProvider).getUserCommunities(
          uid: ref.read(userNotifierProvider.select((value) => value!.uid)));

  Stream<List<CommunityModel>> searchCommunities({required String query}) =>
      ref.read(communityServiceProvider).searchCommunity(query: query);

  Stream<List<PostModel>> getCommunityPosts({required String name}) {
    return ref.read(communityServiceProvider).getCommunityPosts(name: name);
  }
}
