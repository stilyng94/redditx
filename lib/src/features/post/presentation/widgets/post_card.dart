import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/core/application/enums.dart';
import 'package:redditx/src/core/infrastructure/utils.dart';
import 'package:redditx/src/core/presentation/app_theme.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';
import 'package:redditx/src/features/post/application/controller/controller.dart';
import 'package:redditx/src/features/post/application/model/post_model.dart';
import 'package:redditx/src/features/post/application/provider/provider.dart';
import 'package:redditx/src/features/profile/application/provider/provider.dart';

class PostCard extends ConsumerWidget {
  const PostCard(
      {this.communities, this.uid, this.name, this.postModel, super.key});
  final List<CommunityModel>? communities;
  final String? uid;
  final String? name;
  final PostModel? postModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = uid != null
        ? ref.watch(getUserPostsProvider(uid!).select(
            (value) => value.value![ref.read(currentPostIndexProvider)]))
        : name != null
            ? ref.watch(getCommunityPostsProvider(name!).select(
                (value) => value.value![ref.read(currentPostIndexProvider)]))
            : communities != null
                ? ref.watch(getPostsProvider(communities!).select((value) =>
                    value.value![ref.read(currentPostIndexProvider)]))
                : postModel ??
                    ref.watch(getGuestPostsProvider.select((value) =>
                        value.value![ref.read(currentPostIndexProvider)]))!;

    final isAnonymous = ref
        .watch(userNotifierProvider.select((value) => !value!.isAuthenticated));

    ref.listen(postControllerProvider, (previous, next) {
      if (next is ControllerStateFailure) {
        showSnackBar(context, next.message);
      }
      if (next is ControllerStateLoading) {
        showSnackBar(context, 'Loading..');
      }
      if (next is ControllerStateSuccess) {
        showSnackBar(context, 'success');
      }
    });

    final user = ref.watch(userNotifierProvider)!;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).drawerTheme.backgroundColor),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 10)
                          .copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => context.pushNamed('community',
                                        params: {'name': post.communityName}),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          const AssetImage(AssetsPath.logo),
                                      foregroundImage: NetworkImage(
                                          post.communityProfilePic),
                                      radius: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'r/${post.communityName}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () => context.pushNamed(
                                              'profile',
                                              params: {'uid': post.uid}),
                                          child: Text(
                                            'u/${post.username}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                    onPressed: () async {
                                      await ref
                                          .read(postControllerProvider.notifier)
                                          .deletePost(postModel: post)
                                          .run();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppTheme.redColor,
                                    ))
                            ],
                          ),
                          if (post.awards.isNotEmpty) ...[
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 25,
                              child: ListView.builder(
                                  itemCount: post.awards.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Image.asset(
                                        AssetsPath.awards[post.awards[index]]!,
                                        height: 22,
                                      )),
                            )
                          ],
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (post.postType == PostType.image.name)
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(AssetsPath.logo),
                              ),
                            ),
                          if (post.postType == PostType.link.name)
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: AnyLinkPreview(
                                link: post.link!,
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                              ),
                            ),
                          if (post.postType == PostType.text.name)
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          if (!isAnonymous)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await ref
                                              .read(postControllerProvider
                                                  .notifier)
                                              .upVotePost(postModel: post)
                                              .run();
                                        },
                                        icon: Icon(
                                          AssetsPath.up,
                                          size: 30,
                                          color: post.upVotes.contains(user.uid)
                                              ? AppTheme.redColor
                                              : null,
                                        )),
                                    Text(
                                      '${post.upVotes.length - post.downVotes.length == 0 ? "Vote" : post.upVotes.length - post.downVotes.length}',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          await ref
                                              .read(postControllerProvider
                                                  .notifier)
                                              .downVotePost(postModel: post)
                                              .run();
                                        },
                                        icon: Icon(
                                          AssetsPath.down,
                                          size: 30,
                                          color:
                                              post.downVotes.contains(user.uid)
                                                  ? AppTheme.blueColor
                                                  : null,
                                        ))
                                  ],
                                ),
                                Row(
                                  children: [
                                    postModel == null
                                        ? IconButton(
                                            onPressed: () {
                                              context.pushNamed('comments',
                                                  params: {'id': post.id});
                                            },
                                            icon: const Icon(
                                              Icons.comment,
                                            ))
                                        : const SizedBox(),
                                    Text(
                                      '${post.commentCount == 0 ? "Comment" : post.commentCount}',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                ref
                                    .watch(getCommunityProvider(
                                        post.communityName))
                                    .maybeWhen(
                                        data: (data) {
                                          if (data.mods.contains(user.uid)) {
                                            return IconButton(
                                                onPressed: () async {
                                                  await ref
                                                      .read(
                                                          postControllerProvider
                                                              .notifier)
                                                      .deletePost(
                                                          postModel: post)
                                                      .run();
                                                },
                                                icon: const Icon(
                                                  Icons.admin_panel_settings,
                                                ));
                                          }
                                          return const SizedBox();
                                        },
                                        orElse: () => const SizedBox()),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: GridView.builder(
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    2),
                                                        shrinkWrap: true,
                                                        primary: true,
                                                        itemCount:
                                                            user.awards.length,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    ref
                                                                        .read(postControllerProvider
                                                                            .notifier)
                                                                        .awardPost(
                                                                            postModel:
                                                                                post,
                                                                            award: user.awards[
                                                                                index],
                                                                            senderId: user
                                                                                .uid)
                                                                        .run()
                                                                        .whenComplete(() =>
                                                                            context.pop());
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Image.asset(AssetsPath
                                                                        .awards[user
                                                                            .awards[
                                                                        index]]!),
                                                                  ),
                                                                ))),
                                              ));
                                    },
                                    icon: const Icon(Icons.card_giftcard))
                              ],
                            )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
