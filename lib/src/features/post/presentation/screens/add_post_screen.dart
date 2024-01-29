import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/application/enums.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  final double cardHeightWidth = 120;
  final double iconSize = 120;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            context.pushNamed('addPostType',
                params: {'postType': PostType.image.name});
          },
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Theme.of(context).colorScheme.background,
              elevation: 16,
              child: Center(
                  child: Icon(
                Icons.image_outlined,
                size: iconSize,
              )),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.pushNamed('addPostType',
                params: {'postType': PostType.text.name});
          },
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Theme.of(context).colorScheme.background,
              elevation: 16,
              child: Center(
                  child: Icon(
                Icons.font_download_outlined,
                size: iconSize,
              )),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.pushNamed('addPostType',
                params: {'postType': PostType.link.name});
          },
          child: SizedBox(
            height: cardHeightWidth,
            width: cardHeightWidth,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Theme.of(context).colorScheme.background,
              elevation: 16,
              child: Center(
                  child: Icon(
                Icons.link_outlined,
                size: iconSize,
              )),
            ),
          ),
        ),
      ],
    );
  }
}
