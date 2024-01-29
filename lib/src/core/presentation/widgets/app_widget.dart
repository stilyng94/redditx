import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/core/application/providers/theme_controller.dart';
import 'package:redditx/src/core/presentation/app_theme.dart';
import 'package:redditx/src/core/presentation/router.dart';
import 'package:redditx/src/features/auth/application/controller/controller.dart';
import 'package:redditx/src/features/auth/application/model/auth_state.dart';
import 'package:redditx/src/features/auth/application/providers.dart';

class AppWidget extends ConsumerStatefulWidget {
  const AppWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends ConsumerState<AppWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async => await ref
        .read(authControllerProvider.notifier)
        .checkAndUpdateAuthStatus()
        .run());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (_, next) {
      if (next is AuthStateInitial) {
        appRouter.goNamed('splash');
      }
      if (next is AuthStateUnAuthenticated) {
        appRouter.goNamed('login');
      }
    });
    ref.listen(userNotifierProvider, (previous, next) {
      if (next != null) {
        appRouter.goNamed('feed');
      }
    });
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeControllerProvider),
    );
  }
}
