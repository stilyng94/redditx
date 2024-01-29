import 'package:fpdart/fpdart.dart';
import 'package:redditx/src/features/auth/application/model/user_model.dart';
import 'package:redditx/src/features/auth/infrastructure/repository/auth_repository.dart';

class AuthService {
  final IAuthRepository _iAuthRepository;
  AuthService({required IAuthRepository iAuthRepository})
      : _iAuthRepository = iAuthRepository;

  TaskEither<String, UserModel> signIn([bool fromAnonymousLogin = false]) {
    return _iAuthRepository.signIn(fromAnonymousLogin);
  }

  TaskEither<String, Unit> signOut() {
    return _iAuthRepository.signOut();
  }

  TaskEither<String, UserModel> getSignedInUser() {
    return _iAuthRepository.getSignedInUser();
  }

  Stream<UserModel> getUserData(String uid) {
    return _iAuthRepository.getUserData(uid);
  }

  TaskEither<String, UserModel> guestSignIn() {
    return _iAuthRepository.guestSignIn();
  }
}
