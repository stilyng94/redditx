import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/post/application/provider/provider.dart';

class CommentCard extends ConsumerWidget {
  const CommentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentIndex = ref.read(commentIndexProvider);
    final currentComment = ref.read(currentPostIdProvider);
    final isAnonymous = ref
        .watch(userNotifierProvider.select((value) => !value!.isAuthenticated));

    final comment = ref.watch(getCommentsProvider(currentComment)
        .select((value) => value.value![commentIndex]));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.profilePic),
                radius: 18,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'u/${comment.username}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'u/${comment.text}',
                    )
                  ],
                ),
              ))
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: isAnonymous ? null : () {},
                  icon: const Icon(Icons.replay)),
              const Text(
                'Reply',
              )
            ],
          )
        ],
      ),
    );
  }
}
//TODO: Add reply to comment
