import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/application/providers/theme_controller.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/controller/controller.dart';
import 'package:redditx/src/features/auth/application/providers.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider)!;

    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
              foregroundImage: NetworkImage(user.profilePic),
              backgroundImage: const AssetImage(AssetsPath.logo),
              radius: 70),
          const SizedBox(
            height: 12,
          ),
          Text(
            'u/${user.name}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 12,
          ),
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: const Text('My Profile'),
            leading: const Icon(Icons.person),
            onTap: () {
              context.pushNamed('profile', params: {'uid': user.uid});
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            leading: Icon(
              Icons.logout_sharp,
              color: Colors.red.shade500,
            ),
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut().run();
            },
          ),
          Switch.adaptive(
              value: ref.watch(themeControllerProvider) == ThemeMode.dark,
              onChanged: (_) async {
                await ref
                    .read(themeControllerProvider.notifier)
                    .changeTheme()
                    .run();
              })
        ],
      )),
    );
  }
}
