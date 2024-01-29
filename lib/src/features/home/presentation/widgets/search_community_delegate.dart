import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/presentation/assets_path.dart';
import 'package:redditx/src/features/community/application/provider/provider.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef _ref;

  SearchCommunityDelegate(
      {required WidgetRef ref, super.searchFieldLabel = 'community'})
      : _ref = ref;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.close_sharp))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _ref.watch(searchCommunitiesProvider(query)).when(
        data: (communities) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ProviderScope(
                overrides: [
                  currentCommunityIndexProvider.overrideWithValue(index),
                  currentSearchQueryProvider.overrideWithValue(query)
                ],
                child: const SearchItem(),
              );
            },
            itemCount: communities.length,
            primary: true,
            shrinkWrap: true,
          );
        },
        error: (error, _) => Text(error.toString()),
        loading: () {
          return const CircularProgressIndicator.adaptive();
        });
  }
}

class SearchItem extends ConsumerWidget {
  const SearchItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final community = ref.watch(
        searchCommunitiesProvider(ref.read(currentSearchQueryProvider)).select(
            (value) => value.value![ref.read(currentCommunityIndexProvider)]));
    return ListTile(
      onTap: () {
        context.pushNamed('community', params: {'name': community.name});
      },
      title: Text('r/${community.name}'),
      leading: CircleAvatar(
          backgroundImage: const AssetImage(AssetsPath.logo),
          foregroundImage: NetworkImage(community.avatarUrl)),
    );
  }
}
