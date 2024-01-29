import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/controller/controller.dart';

class SignInButtonWidget extends ConsumerWidget {
  const SignInButtonWidget({Key? key, this.fromAnonymousLogin = false})
      : super(key: key);
  final bool fromAnonymousLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          await ref.read(authControllerProvider.notifier).signIn().run();
        },
        icon: Image.asset(AssetsPath.googleIcon, width: 35),
        label: const Text(
          'Continue with Google',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
