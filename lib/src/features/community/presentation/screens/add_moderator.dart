import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redditx/src/features/auth/application/providers.dart';
import 'package:redditx/src/features/community/application/controller/controller.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';

class AddModeratorScreen extends ConsumerWidget {
  const AddModeratorScreen({required this.name, super.key});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () async {
              await ref
                  .read(communityControllerProvider.notifier)
                  .addMods(communityName: name)
                  .run();
            },
            icon: const Icon(Icons.done_sharp))
      ]),
      body: ref.watch(getCommunityProvider(name)).when(
          data: (community) => ListView.builder(
                itemBuilder: ((context, index) {
                  final member = community.members[index];

                  if (community.mods.contains(member)) {
                    ref.read(toggleModeratorStatusProvider).add(member);
                  }

                  return ProviderScope(
                    overrides: [
                      currentMemberUidProvider.overrideWithValue(member)
                    ],
                    child: const AddModeratorCheckBox(),
                  );
                }),
                itemCount: community.members.length,
              ),
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator.adaptive()),
    );
  }
}

class AddModeratorCheckBox extends ConsumerWidget {
  const AddModeratorCheckBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser =
        ref.watch(streamUserProvider(ref.read(currentMemberUidProvider)));

    return asyncUser.when(
        data: (user) => CheckboxListTile(
              value: ref
                  .watch(toggleModeratorStatusProvider)
                  .contains(ref.watch(currentMemberUidProvider)),
              title: Text('u/${user.name}'),
              onChanged: ref.watch(userNotifierProvider)!.uid ==
                      ref.watch(currentMemberUidProvider)
                  ? null
                  : ((value) {
                      if (value!) {
                        ref
                            .read(toggleModeratorStatusProvider)
                            .add(ref.read(currentMemberUidProvider));
                      } else {
                        ref
                            .read(toggleModeratorStatusProvider)
                            .remove(ref.read(currentMemberUidProvider));
                      }
                    }),
            ),
        error: (error, _) => Container(),
        loading: () => const CircularProgressIndicator.adaptive());
  }
}
