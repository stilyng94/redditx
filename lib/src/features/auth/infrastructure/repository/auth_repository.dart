import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/model/user_model.dart';

abstract class IAuthRepository {
  TaskEither<String, UserModel> signIn([bool fromAnonymousLogin = false]);
  TaskEither<String, UserModel> guestSignIn();
  TaskEither<String, Unit> signOut();
  TaskEither<String, UserModel> getSignedInUser();
  Stream<UserModel> getUserData(String uid);
}

class HttpAuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;

  HttpAuthRepository(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firebaseFirestore,
      required GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _usersRef => _firebaseFirestore.collection('users');

  @override
  TaskEither<String, UserModel> signIn([bool fromAnonymousLogin = false]) {
    return TaskEither.tryCatch(() async {
      late UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
        googleAuthProvider = googleAuthProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential =
            await _firebaseAuth.signInWithPopup(googleAuthProvider);
      } else {
        final googleUser = await _googleSignIn.signIn();
        final tokens = await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: tokens?.accessToken, idToken: tokens?.idToken);

        if (fromAnonymousLogin) {
          userCredential =
              await _firebaseAuth.currentUser!.linkWithCredential(credential);
        } else {
          userCredential = await _firebaseAuth.signInWithCredential(credential);
        }
      }

      final user = userCredential.user!;

      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            email: user.email ?? '',
            profilePic: user.photoURL ?? AssetsPath.avatarDefault,
            banner: AssetsPath.bannerDefault,
            uid: user.uid,
            isAuthenticated: true,
            karma: 0,
            name: user.displayName ?? '',
            awards: AssetsPath.awards.keys.toList());
        await _usersRef.doc(user.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(user.uid).first;
      }
      return userModel;
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, Unit> signOut() {
    return TaskEither.tryCatch(() async {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return unit;
    }, (error, stackTrace) => error.toString());
  }

  @override
  TaskEither<String, UserModel> getSignedInUser() {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return TaskEither.left('user not found');
    }
    return TaskEither.tryCatch(() async {
      return await getUserData(user.uid).first;
    }, (error, stackTrace) => error.toString());
  }

  @override
  Stream<UserModel> getUserData(String uid) {
    return _usersRef.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  @override
  TaskEither<String, UserModel> guestSignIn() {
    return TaskEither.tryCatch(() async {
      final userCredential = await _firebaseAuth.signInAnonymously();
      final user = userCredential.user!;

      final userModel = UserModel(
          email: 'guest@anonymous.guest,',
          profilePic: AssetsPath.avatarDefault,
          banner: AssetsPath.bannerDefault,
          uid: user.uid,
          isAuthenticated: false,
          karma: 0,
          name: 'Guest',
          awards: const []);

      await _usersRef.doc(user.uid).set(userModel.toMap());

      return userModel;
    }, (error, stackTrace) => error.toString());
  }
}
