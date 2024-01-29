import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/features/auth/application/model/auth_state.dart';
import 'package:redditx/src/features/auth/application/model/user_model.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    return AuthStateInitial();
  }

  Task<Unit> signIn({bool fromAnonymousLogin = false}) {
    return Task(() async {
      state = AuthStateLoading();
      final failureOrSuccess =
          await ref.read(authServiceProvider).signIn(fromAnonymousLogin).run();
      state = failureOrSuccess.fold((l) {
        ref.invalidate(userNotifierProvider);
        return AuthStateFailure(l);
      }, (r) {
        ref.read(userNotifierProvider.notifier).state = r;
        return AuthStateAuthenticated();
      });
      return unit;
    });
  }

  Task<Unit> signOut() {
    return Task(() async {
      final failureOrSuccess =
          await ref.read(authServiceProvider).signOut().run();
      ref.invalidate(userNotifierProvider);
      state = failureOrSuccess.fold(
          (l) => AuthStateUnAuthenticated(), (r) => AuthStateUnAuthenticated());
      return unit;
    });
  }

  Task<Unit> checkAndUpdateAuthStatus() {
    return Task(() async {
      final failureOrSuccess =
          await ref.read(authServiceProvider).getSignedInUser().run();
      state = failureOrSuccess.fold((l) {
        ref.invalidate(userNotifierProvider);
        return AuthStateUnAuthenticated();
      }, (r) {
        ref.read(userNotifierProvider.notifier).state = r;
        return AuthStateAuthenticated();
      });
      return unit;
    });
  }

  Stream<UserModel> getUserData(String uid) {
    return ref.read(iAuthRepositoryProvider).getUserData(uid);
  }

  Task<Unit> guestSignIn() {
    return Task(() async {
      state = AuthStateLoading();
      final failureOrSuccess =
          await ref.read(authServiceProvider).guestSignIn().run();
      state = failureOrSuccess.fold((l) {
        ref.invalidate(userNotifierProvider);
        return AuthStateFailure(l);
      }, (r) {
        ref.read(userNotifierProvider.notifier).state = r;
        return AuthStateAuthenticated();
      });
      return unit;
    });
  }
}
