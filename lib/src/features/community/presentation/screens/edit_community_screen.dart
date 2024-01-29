import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/infrastructure/helpers/file_helpers.dart';
import 'package:redditx/src/core/presentation/app_theme.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/community/application/controller/controller.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  const EditCommunityScreen({required this.name, super.key});
  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _EditCommunityScreenState();
  }
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  Uint8List? bannerFileBytes;
  Uint8List? profileFileBytes;

  Future<void> selectBannerImage() async {
    await pickAndReadImageToBytes().match((l) => null, (bytes) {
      setState(() {
        bannerFileBytes = bytes;
      });
    }).run();
  }

  Future<void> selectProfileImage() async {
    await pickAndReadImageToBytes().match((l) => null, (bytes) {
      setState(() {
        profileFileBytes = bytes;
      });
    }).run();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(communityControllerProvider, (previous, next) {
      if (next is ControllerStateFailure) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(next.message),
          ));
      }
      if (next is ControllerStateLoading) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text('loading....'),
          ));
      }
      if (next is ControllerStateSuccess) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text('success....'),
          ));
        context.pop();
      }
    });

    final asyncValueCommunity = ref.watch(getCommunityProvider(widget.name));

    return Scaffold(
        backgroundColor: AppTheme.darkTheme.colorScheme.background,
        appBar: AppBar(
          title: const Text('edit'),
          centerTitle: false,
          actions: [
            TextButton(
                onPressed: asyncValueCommunity.error != null
                    ? null
                    : () async {
                        await ref
                            .read(communityControllerProvider.notifier)
                            .editCommunity(
                                bannerFileBytes: bannerFileBytes,
                                profileFileBytes: profileFileBytes,
                                community: asyncValueCommunity.requireValue)
                            .run();
                      },
                child: const Text('save'))
          ],
        ),
        body: asyncValueCommunity.when(
            data: (community) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await selectBannerImage();
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            strokeCap: StrokeCap.round,
                            dashPattern: const [10, 4],
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color!,
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: bannerFileBytes != null
                                  ? Image.memory(bannerFileBytes!)
                                  : community.banner.isEmpty ||
                                          community.banner == AssetsPath.logo
                                      ? const Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                          ),
                                        )
                                      : Image.network(community.banner),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          bottom: 20,
                          child: GestureDetector(
                            onTap: () async {
                              await selectProfileImage();
                            },
                            child: profileFileBytes != null
                                ? CircleAvatar(
                                    radius: 32,
                                    foregroundImage:
                                        MemoryImage(bannerFileBytes!),
                                    backgroundImage:
                                        const AssetImage(AssetsPath.logo),
                                  )
                                : CircleAvatar(
                                    radius: 32,
                                    foregroundImage:
                                        NetworkImage(community.avatarUrl),
                                    backgroundImage:
                                        const AssetImage(AssetsPath.logo),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            error: (error, _) => Text(error.toString()),
            loading: () => const CircularProgressIndicator.adaptive()));
  }
}
