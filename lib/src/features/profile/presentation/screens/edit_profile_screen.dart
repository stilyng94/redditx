import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/core/application/controller_state.dart';
import 'package:redditx/src/core/infrastructure/helpers/file_helpers.dart';
import 'package:redditx/src/core/infrastructure/utils.dart';
import 'package:redditx/src/core/presentation/app_theme.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/profile/application/controller/controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({required this.uid, super.key});
  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  Uint8List? bannerFileBytes;
  Uint8List? profileFileBytes;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: ref.read(userNotifierProvider)!.name);
  }

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
    ref.listen(userProfileControllerProvider, (previous, next) {
      if (next is ControllerStateFailure) {
        showSnackBar(context, next.message);
      }
      if (next is ControllerStateLoading) {
        showSnackBar(context, 'loading...');
      }
      if (next is ControllerStateSuccess) {
        showSnackBar(context, 'success');
      }
    });

    final asyncUser = ref.watch(streamUserProvider(widget.uid));

    return Scaffold(
        backgroundColor: AppTheme.darkTheme.colorScheme.background,
        appBar: AppBar(
          title: const Text('edit'),
          centerTitle: false,
          actions: [
            TextButton(
                onPressed: asyncUser.error != null
                    ? null
                    : () async {
                        await ref
                            .read(userProfileControllerProvider.notifier)
                            .editUserProfile(
                                bannerFileBytes: bannerFileBytes,
                                profileFileBytes: profileFileBytes,
                                name: nameController.text.trim())
                            .run();
                      },
                child: const Text('save'))
          ],
        ),
        body: asyncUser.when(
            data: (user) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
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
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!,
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: bannerFileBytes != null
                                      ? Image.memory(bannerFileBytes!)
                                      : user.banner.isEmpty ||
                                              user.banner == AssetsPath.logo
                                          ? const Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ),
                                            )
                                          : Image.network(user.banner),
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
                                            NetworkImage(user.profilePic),
                                        backgroundImage:
                                            const AssetImage(AssetsPath.logo),
                                      ),
                              ),
                            )
                          ],
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            filled: true,
                            hintText: 'Name',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.blue)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(18)),
                      )
                    ],
                  ),
                ),
            error: (error, _) => Text(error.toString()),
            loading: () => const CircularProgressIndicator.adaptive()));
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
