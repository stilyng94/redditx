import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';
import 'package:redditx/src/features/post/application/provider/provider.dart';
import 'package:redditx/src/features/post/presentation/widgets/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAnonymous = ref
        .watch(userNotifierProvider.select((value) => !value!.isAuthenticated));

    if (isAnonymous) {
      return ref.watch(getGuestPostsProvider).when(
          data: (posts) => RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(getPostsProvider);
                  return ref.read(getGuestPostsProvider.stream);
                },
                child: ListView.separated(
                    separatorBuilder: ((context, index) => const SizedBox(
                          height: 10,
                        )),
                    itemCount: posts.length,
                    shrinkWrap: true,
                    primary: true,
                    itemBuilder: (context, index) => ProviderScope(
                          overrides: [
                            currentPostIndexProvider.overrideWithValue(index)
                          ],
                          child: const PostCard(),
                        )),
              ),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const CircularProgressIndicator.adaptive());
    }

    return ref.watch(getUserCommunitiesProvider).when(
        data: (communities) {
          return communities.isEmpty
              ? const SizedBox()
              : ref.watch(getPostsProvider(communities)).when(
                  data: (posts) => RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(getPostsProvider);
                          return ref.read(getPostsProvider(communities).stream);
                        },
                        child: ListView.separated(
                            separatorBuilder: ((context, index) =>
                                const SizedBox(
                                  height: 10,
                                )),
                            itemCount: posts.length,
                            shrinkWrap: true,
                            primary: true,
                            itemBuilder: (context, index) => ProviderScope(
                                  overrides: [
                                    currentPostIndexProvider
                                        .overrideWithValue(index)
                                  ],
                                  child: PostCard(communities: communities),
                                )),
                      ),
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator.adaptive());
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const CircularProgressIndicator.adaptive());
  }
}
