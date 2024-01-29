import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/core/infrastructure/utils.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/controller/controller.dart';
import 'package:redditx/src/features/auth/application/model/auth_state.dart';
import 'package:redditx/src/features/auth/presentation/widgets/signin_button_widget.dart';
import 'package:redditx/src/features/home/presentation/screens/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (_, next) {
      if (next is AuthStateFailure) {
        showSnackBar(context, next.message);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return HomeScreen(child: Container());
          },
        ));
      }
      if (next is AuthStateLoading) {
        showSnackBar(context, 'Loading...');
      }
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () async => await ref
                  .read(authControllerProvider.notifier)
                  .guestSignIn()
                  .run(),
              child: const Text(
                'Skip',
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
        title: Image.asset(
          AssetsPath.logo,
          height: 40,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Dive into anything',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    AssetsPath.logo,
                    height: 100,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const SignInButtonWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
