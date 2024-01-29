import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/features/auth/presentation/screens/login_screen.dart';
import 'package:redditx/src/features/community/presentation/screens/add_moderator.dart';
import 'package:redditx/src/features/community/presentation/screens/community_screen.dart';
import 'package:redditx/src/features/community/presentation/screens/create_community_screen.dart';
import 'package:redditx/src/features/community/presentation/screens/edit_community_screen.dart';
import 'package:redditx/src/features/community/presentation/screens/mod_tools_screen.dart';
import 'package:redditx/src/features/feed/presentation/screens/feed_screen.dart';
import 'package:redditx/src/features/home/presentation/screens/home_screen.dart';
import 'package:redditx/src/features/post/presentation/screens/add_post_screen.dart';
import 'package:redditx/src/features/post/presentation/screens/add_post_type_screen.dart';
import 'package:redditx/src/features/post/presentation/screens/comments_screen.dart';
import 'package:redditx/src/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:redditx/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:redditx/src/features/splash/presentation/screens/splash_screen.dart';

final _parentKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _parentKey,
  routes: [
    ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) {
          return HomeScreen(
            child: child,
          );
        },
        routes: [
          GoRoute(
              path: '/feed',
              parentNavigatorKey: _shellKey,
              name: 'feed',
              builder: (context, state) {
                return const FeedScreen();
              },
              routes: [
                GoRoute(
                  name: 'comments',
                  path: ':id/comments',
                  parentNavigatorKey: _parentKey,
                  builder: (BuildContext context, GoRouterState state) {
                    return CommentsScreen(
                      id: state.params['id']!,
                    );
                  },
                ),
              ]),
          GoRoute(
              path: '/add-post',
              name: 'addPost',
              parentNavigatorKey: _shellKey,
              builder: (context, state) {
                return const AddPostScreen();
              },
              routes: [
                GoRoute(
                  name: 'addPostType',
                  path: ':postType',
                  parentNavigatorKey: _parentKey,
                  builder: (BuildContext context, GoRouterState state) {
                    return AddPostTypeScreen(
                      postType: state.params['postType']!,
                    );
                  },
                ),
              ]),
        ]),
    GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) {
          return const SplashScreen();
        }),
    GoRoute(
      path: '/login',
      parentNavigatorKey: _parentKey,
      name: 'login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/create-community',
      name: 'createCommunity',
      builder: (context, state) {
        return const CreateCommunityScreen();
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/r/:name',
      name: 'community',
      builder: (context, state) {
        return CommunityScreen(
          name: state.params['name']!,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/edit-community/:name',
      name: 'editCommunity',
      builder: (context, state) {
        return EditCommunityScreen(
          name: state.params['name']!,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/u/:uid',
      name: 'profile',
      builder: (context, state) {
        return ProfileScreen(
          uid: state.params['uid']!,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/edit-profile/:uid',
      name: 'editProfile',
      builder: (context, state) {
        return EditProfileScreen(
          uid: state.params['uid']!,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/mod-tools/:name',
      name: 'modTools',
      builder: (context, state) {
        return ModToolsScreen(
          name: state.params['name']!,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _parentKey,
      path: '/add-mods/:name',
      name: 'addMods',
      builder: (context, state) {
        return AddModeratorScreen(
          name: state.params['name']!,
        );
      },
    ),
  ],
  debugLogDiagnostics: true,
);
