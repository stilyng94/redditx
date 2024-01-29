import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/core/application/enums.dart';
import 'package:redditx/src/features/auth/application/model/user_model.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';
import 'package:redditx/src/features/profile/application/provider/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'controller.g.dart';

@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  ControllerState build() {
    return ControllerStateInitial();
  }

  Task<Unit> editUserProfile({
    required Uint8List? bannerFileBytes,
    required Uint8List? profileFileBytes,
    required String? name,
  }) {
    return Task(() async {
      state = ControllerStateLoading();
      final user = ref.read(userNotifierProvider)!;
      final res = await ref
          .read(userProfileServiceProvider)
          .editProfile(
              user: user,
              bannerFileBytes: bannerFileBytes,
              profileFileBytes: profileFileBytes,
              name: name)
          .run();
      state = res.match((l) => ControllerStateFailure(l), (r) {
        ref.read(userNotifierProvider.notifier).state = r;
        return ControllerStateSuccess();
      });
      return unit;
    });
  }

  Stream<List<PostModel>> getPosts({required String uid}) {
    return ref.read(userProfileServiceProvider).getPosts(uid: uid);
  }

  Task<Unit> updateKarma({required Karma karma}) {
    return Task(() async {
      state = ControllerStateLoading();
      UserModel user = ref.read(userNotifierProvider)!;
      user = user.copyWith(karma: user.karma + karma.point);

      final res = await ref
          .read(userProfileServiceProvider)
          .updateKarma(user: user)
          .run();
      state = res.match((l) => ControllerStateFailure(l), (r) {
        ref.read(userNotifierProvider.notifier).state = user;

        return ControllerStateSuccess();
      });
      return unit;
    });
  }
}
