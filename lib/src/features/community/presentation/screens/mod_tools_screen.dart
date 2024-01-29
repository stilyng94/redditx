import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ModToolsScreen extends ConsumerWidget {
  const ModToolsScreen({required this.name, super.key});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mod Tools')),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              context.pushNamed('addMods', params: {'name': name});
            },
            leading: const Icon(Icons.add_moderator_sharp),
            title: const Text('Add Moderators'),
          ),
          ListTile(
            onTap: () {
              context.pushNamed('editCommunity', params: {'name': name});
            },
            leading: const Icon(Icons.mode_edit_sharp),
            title: const Text('Edit Community'),
          )
        ],
      ),
    );
  }
}
