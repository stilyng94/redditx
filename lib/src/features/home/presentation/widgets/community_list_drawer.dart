import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/auth/presentation/widgets/signin_button_widget.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';

class CommunityListDrawerWidget extends ConsumerWidget {
  const CommunityListDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref
        .watch(userNotifierProvider.select((value) => value!.isAuthenticated));

    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          if (!isAuthenticated)
            const SignInButtonWidget(
              fromAnonymousLogin: true,
            ),
          ...[
            ListTile(
              title: const Text('Create community'),
              leading: const Icon(Icons.add),
              onTap: () {
                context.pushNamed('createCommunity');
              },
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
                child: RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(getUserCommunitiesProvider);
                      return ref.read(getUserCommunitiesProvider.stream);
                    },
                    child: ref.watch(getUserCommunitiesProvider).when(
                        data: (communities) {
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            itemBuilder: ((context, index) {
                              return ProviderScope(
                                overrides: [
                                  currentCommunityIndexProvider
                                      .overrideWithValue(index)
                                ],
                                child: const _ListBody(),
                              );
                            }),
                            shrinkWrap: true,
                            primary: true,
                            separatorBuilder: ((context, index) =>
                                const Divider()),
                            itemCount: communities.length,
                          );
                        },
                        error: (error, _) => Text(error.toString()),
                        loading: () =>
                            const CircularProgressIndicator.adaptive())))
          ]
        ],
      )),
    );
  }
}

class _ListBody extends ConsumerWidget {
  const _ListBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final community = ref.watch(getUserCommunitiesProvider.select(
        (value) => value.value![ref.read(currentCommunityIndexProvider)]));
    return ListTile(
      onTap: () {
        context.pushNamed('community', params: {'name': community.name});
      },
      title: Text('r/${community.name}'),
      leading: CircleAvatar(
        foregroundImage: NetworkImage(community.avatarUrl),
        backgroundImage: const AssetImage(AssetsPath.logo),
      ),
    );
  }
}
