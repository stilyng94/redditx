import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/home/presentation/widgets/community_list_drawer.dart';
import 'package:redditx/src/features/home/presentation/widgets/profile_drawer.dart';
import 'package:redditx/src/features/home/presentation/widgets/search_community_delegate.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({required this.child, super.key});
  final Widget child;

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;
    if (location.startsWith('/add-post')) {
      return 1;
    }
    if (location.startsWith('/feed')) {
      return 0;
    }
    return 0;
  }

  void onTap(int value, BuildContext context) {
    switch (value) {
      case 1:
        return context.go('/add-post');
      case 0:
        return context.go('/feed');
      default:
        return context.go('/feed');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_sharp),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchCommunityDelegate(ref: ref));
            },
          ),
          if (kIsWeb) IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: const AssetImage(AssetsPath.logo),
                foregroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: user.isAuthenticated
                  ? () => Scaffold.of(context).openEndDrawer()
                  : null,
            );
          })
        ],
      ),
      body: child,
      bottomNavigationBar: user.isAuthenticated && !kIsWeb
          ? BottomNavigationBar(
              currentIndex: _calculateSelectedIndex(context),
              onTap: (index) => onTap(index, context),
              items: const [
                BottomNavigationBarItem(label: '', icon: Icon(Icons.home)),
                BottomNavigationBarItem(label: '', icon: Icon(Icons.add)),
              ],
              selectedItemColor: Theme.of(context).iconTheme.color,
              backgroundColor: Theme.of(context).colorScheme.background,
            )
          : null,
      drawer: const CommunityListDrawerWidget(),
      endDrawer: user.isAuthenticated ? const ProfileDrawer() : null,
    );
  }
}
