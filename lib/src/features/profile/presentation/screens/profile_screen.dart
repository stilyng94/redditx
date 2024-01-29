import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/core/infrastructure/utils.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/community/application/controller/controller.dart';
import 'package:redditx/src/features/post/application/provider/provider.dart';
import 'package:redditx/src/features/post/presentation/widgets/post_card.dart';
import 'package:redditx/src/features/profile/application/provider/provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({required this.uid, super.key});
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(streamUserProvider(uid));
    final asyncUserPosts = ref.watch(getUserPostsProvider(uid));

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
      body: asyncUser.when(
          data: (user) {
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      SliverAppBar(
                        expandedHeight: 250,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                                child: Image.network(
                              user.banner,
                            )),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  const EdgeInsets.all(20).copyWith(bottom: 70),
                              child: CircleAvatar(
                                radius: 45,
                                foregroundImage: NetworkImage(user.profilePic),
                                backgroundImage:
                                    const AssetImage(AssetsPath.logo),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(20),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {
                                    context.pushNamed('editProfile',
                                        params: {'uid': uid});
                                  },
                                  child: const Text('Edit Profile')),
                            )
                          ],
                        ),
                      ),
                      SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(
                              delegate: SliverChildListDelegate([
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'u/${user.name}',
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text('${user.karma} karma'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 2,
                            )
                          ])))
                    ],
                body: asyncUserPosts.when(
                    data: (posts) => RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(getUserPostsProvider);
                            return ref.read(getUserPostsProvider(uid).stream);
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
                                    child: PostCard(uid: uid),
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
