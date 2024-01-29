import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/core/infrastructure/utils.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/post/application/controller/controller.dart';
import 'package:redditx/src/features/post/application/provider/provider.dart';
import 'package:redditx/src/features/post/presentation/widgets/comment_card.dart';
import 'package:redditx/src/features/post/presentation/widgets/post_card.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  const CommentsScreen({required this.id, super.key});
  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final asyncPost = ref.watch(getPostByIdProvider(widget.id));
    final isAnonymous = ref
        .watch(userNotifierProvider.select((value) => !value!.isAuthenticated));

    ref.listen(postControllerProvider, (prev, next) {
      if (next is ControllerStateFailure) {
        showSnackBar(context, next.message);
      }
      if (next is ControllerStateLoading) {
        showSnackBar(context, 'Loading..');
      }
      if (next is ControllerStateSuccess) {
        showSnackBar(context, 'success');
        commentController.clear();
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: asyncPost.when(
          data: (post) {
            return Column(
              children: [
                PostCard(
                  postModel: post,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: commentController,
                  readOnly: isAnonymous,
                  enabled: !isAnonymous,
                  onSubmitted: (value) async => await ref
                      .read(postControllerProvider.notifier)
                      .addComment(text: value.trim(), postId: post.id)
                      .run(),
                  decoration: const InputDecoration(
                      hintText: 'Free ur mind!!',
                      filled: true,
                      border: InputBorder.none),
                ),
                const SizedBox(
                  height: 12,
                ),
                ref.watch(getCommentsProvider(widget.id)).when(
                    data: (data) => Expanded(
                          child: ListView.builder(
                              itemCount: data.length,
                              shrinkWrap: true,
                              primary: true,
                              itemBuilder: (_, index) {
                                return ProviderScope(
                                  overrides: [
                                    commentIndexProvider
                                        .overrideWithValue(index),
                                    currentPostIdProvider
                                        .overrideWithValue(post.id)
                                  ],
                                  child: const CommentCard(),
                                );
                              }),
                        ),
                    error: (error, _) => Text(error.toString()),
                    loading: () => const CircularProgressIndicator.adaptive())
              ],
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const CircularProgressIndicator.adaptive()),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
