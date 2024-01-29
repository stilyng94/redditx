import 'package:flutter/material.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsPath.logo,
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 16,
            ),
            const LinearProgressIndicator(semanticsLabel: 'Loading')
          ],
        ),
      ),
    );
  }
}
