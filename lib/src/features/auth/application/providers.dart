import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/core/application/providers/firebase_providers.dart';
import 'package:redditx/src/features/auth/application/controller/controller.dart';
import 'package:redditx/src/features/auth/application/model/user_model.dart';
import 'package:redditx/src/features/auth/infrastructure/repository/auth_repository.dart';
import 'package:redditx/src/features/auth/infrastructure/service/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IAuthRepository iAuthRepository(IAuthRepositoryRef ref) {
  throw UnimplementedError();
}

@riverpod
HttpAuthRepository remoteAuthRepository(RemoteAuthRepositoryRef ref) {
  return HttpAuthRepository(
      firebaseAuth: ref.watch(firebaseAuthProvider),
      firebaseFirestore: ref.watch(firebaseFireStoreProvider),
      googleSignIn: ref.watch(googleSignInProvider));
}

@riverpod
AuthService authService(AuthServiceRef ref) =>
    AuthService(iAuthRepository: ref.watch(iAuthRepositoryProvider));

@riverpod
Future<void> triggerAuthCheck(TriggerAuthCheckRef ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  await authController.checkAndUpdateAuthStatus().run();
}

final streamUserProvider =
    StreamProvider.family.autoDispose<UserModel, String>((ref, uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  UserModel? build() {
    return null;
  }
}
