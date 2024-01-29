import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:redditx/src/core/application/providers/theme_controller.dart';
import 'package:redditx/src/core/infrastructure/object_storage_repository.dart';
import 'package:redditx/src/core/infrastructure/provider_logger.dart';
import 'package:redditx/src/core/presentation/widgets/app_widget.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';
import 'package:redditx/src/features/post/application/provider/provider.dart';
import 'package:redditx/src/features/profile/application/provider/provider.dart';
import 'src/core/application/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  final themeBox = await Hive.openBox<String>('theme');

  runApp(ProviderScope(observers: [
    ProviderLogger()
  ], overrides: [
    themeBoxProvider.overrideWithValue(themeBox),
    iAuthRepositoryProvider
        .overrideWith((ref) => ref.watch(remoteAuthRepositoryProvider)),
    iObjectStorageRepositoryProvider.overrideWith(
        (ref) => ref.watch(objectStorageRepositoryWithFirebaseStorageProvider)),
    iCommunityRepositoryProvider
        .overrideWith((ref) => ref.watch(httpCommunityRepositoryProvider)),
    iUserProfileRepositoryProvider
        .overrideWith((ref) => ref.watch(httpUserProfileRepositoryProvider)),
    iPostRepositoryProvider
        .overrideWith((ref) => ref.watch(httpPostRepositoryProvider))
  ], child: const AppWidget()));
}
