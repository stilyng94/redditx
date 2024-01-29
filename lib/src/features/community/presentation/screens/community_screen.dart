import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/infrastructure/utils.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/community/application/controller/controller.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';
import 'package:redditx/src/features/post/application/provider/provider.dart';
import 'package:redditx/src/features/post/presentation/widgets/post_card.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({required this.name, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValueCommunity = ref.watch(getCommunityProvider(name));
    final userId =
        ref.watch(userNotifierProvider.select((value) => value!.uid));
    final isAnonymous = ref
        .watch(userNotifierProvider.select((value) => !value!.isAuthenticated));

    final asyncCommunityPosts = ref.watch(getCommunityPostsProvider(name));

    ref.listen(communityControllerProvider, (previous, next) {
      if (next is ControllerStateFailure) {
        showSnackBar(context, next.message);
      }
      if (next is ControllerStateLoading) {
        showSnackBar(context, 'Loading..');
      }
      if (next is ControllerStateSuccess) {
        showSnackBar(context, 'success');
        context.pop();
      }
    });

    return Scaffold(
      body: asyncValueCommunity.when(
          data: (community) {
            final isAdmin = community.mods.contains(userId);
            final isMember = community.members.contains(userId);

            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        expandedHeight: 150,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                                child: Image.network(
                              community.banner,
                              fit: BoxFit.cover,
                            ))
                          ],
                        ),
                      ),
                      SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(
                              delegate: SliverChildListDelegate([
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                radius: 35,
                                foregroundImage:
                                    NetworkImage(community.avatarUrl),
                                backgroundImage:
                                    const AssetImage(AssetsPath.logo),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'r/${community.name}',
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (!isAnonymous)
                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      onPressed: () {
                                        isAdmin
                                            ? context.pushNamed('modTools',
                                                params: {
                                                    'name': community.name
                                                  })
                                            : () async {
                                                await ref
                                                    .read(
                                                        communityControllerProvider
                                                            .notifier)
                                                    .joinOrLeaveCommunity(
                                                        communityName:
                                                            community.name,
                                                        isMember: isMember,
                                                        userId: userId)
                                                    .run();
                                              };
                                      },
                                      child: isAdmin
                                          ? const Text('Mod Tools')
                                          : isMember
                                              ? const Text('Joined')
                                              : const Text('Join'))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child:
                                  Text('${community.members.length} members'),
                            )
                          ])))
                    ],
                body: asyncCommunityPosts.when(
                    data: (posts) => RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(getCommunityPostsProvider);
                            return ref
                                .read(getCommunityPostsProvider(name).stream);
                          },
                          child: ListView.separated(
                              separatorBuilder: ((context, index) =>
                                  const Divider()),
                              itemCount: posts.length,
                              shrinkWrap: true,
                              primary: true,
                              itemBuilder: (context, index) => ProviderScope(
                                    overrides: [
                                      currentPostIndexProvider
                                          .overrideWithValue(index)
                                    ],
                                    child: PostCard(name: name),
                                  )),
                        ),
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => const CircularProgressIndicator.adaptive()));
          },
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator.adaptive()),
    );
  }
}
