import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/core/application/enums.dart';
import 'package:redditx/src/core/infrastructure/helpers/file_helpers.dart';
import 'package:redditx/src/core/infrastructure/utils.dart';
import 'package:redditx/src/features/community/application/model/community_model.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';
import 'package:redditx/src/features/post/application/controller/controller.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  const AddPostTypeScreen({required this.postType, super.key});
  final String postType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionOrLinkController = TextEditingController();

  Uint8List? bannerFileBytes;
  CommunityModel? selectedCommunity;

  Future<void> selectBannerImage() async {
    await pickAndReadImageToBytes().match((l) => null, (bytes) {
      setState(() {
        bannerFileBytes = bytes;
      });
    }).run();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(postControllerProvider, (previous, next) {
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
    final asyncCommunities = ref.watch(getUserCommunitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.postType}'),
        actions: [
          TextButton(
              onPressed: titleController.text.trim().isNotEmpty &&
                      selectedCommunity != null &&
                      (descriptionOrLinkController.text.trim().isNotEmpty ||
                          bannerFileBytes != null)
                  ? sharePost
                  : null,
              child: const Text('Share'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                maxLength: 30,
                decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Enter title here',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18)),
              ),
              const SizedBox(
                height: 12,
              ),
              if (widget.postType == PostType.image.name)
                GestureDetector(
                  onTap: () async {
                    await selectBannerImage();
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    strokeCap: StrokeCap.round,
                    dashPattern: const [10, 4],
                    color: Theme.of(context).textTheme.bodyMedium!.color!,
                    child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: bannerFileBytes != null
                            ? Image.memory(bannerFileBytes!)
                            : const Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                ),
                              )),
                  ),
                ),
              if (widget.postType == PostType.text.name)
                TextField(
                  controller: descriptionOrLinkController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Description here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)),
                ),
              if (widget.postType == PostType.link.name)
                TextField(
                  controller: descriptionOrLinkController,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Link here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)),
                ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text('select Community'),
              ),
              asyncCommunities.when(
                  data: (communities) {
                    return communities.isEmpty
                        ? const SizedBox()
                        : DropdownButton(
                            items: communities
                                .map((community) => DropdownMenuItem(
                                      key: Key(community.id),
                                      value: community,
                                      child: Text(community.name),
                                    ))
                                .toList(),
                            value: selectedCommunity ?? communities.first,
                            onChanged: (community) => setState(() {
                                  selectedCommunity = community;
                                }));
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator.adaptive())
            ],
          ),
        ),
      ),
    );
  }

  void sharePost() async {
    final postController = ref.read(postControllerProvider.notifier);
    switch (widget.postType) {
      case 'image':
        await postController
            .shareImagePost(
                title: titleController.text,
                communityModel: selectedCommunity!,
                objectBytes: bannerFileBytes!)
            .run();
        break;
      case 'link':
        await postController
            .shareLinkPost(
                title: titleController.text,
                communityModel: selectedCommunity!,
                link: descriptionOrLinkController.text)
            .run();
        break;
      default:
        await postController
            .shareTextPost(
                title: titleController.text,
                communityModel: selectedCommunity!,
                description: descriptionOrLinkController.text)
            .run();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionOrLinkController.dispose();
    super.dispose();
  }
}
