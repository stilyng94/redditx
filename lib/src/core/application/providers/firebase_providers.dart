import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'firebase_providers.g.dart';

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@riverpod
FirebaseStorage firebaseStorage(FirebaseStorageRef ref) =>
    FirebaseStorage.instance;

@riverpod
FirebaseFirestore firebaseFireStore(FirebaseFireStoreRef ref) =>
    FirebaseFirestore.instance;

@riverpod
GoogleSignIn googleSignIn(GoogleSignInRef ref) => GoogleSignIn();
