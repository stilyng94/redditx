import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:redditx/src/core/infrastructure/utils.dart';
import 'package:redditx/src/features/community/application/controller/controller.dart';
import 'package:redditx/src/core/application/controller_state.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(communityControllerProvider, (previous, next) {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Create Community')),
      body: Center(
          child: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.topLeft, child: Text('Community name')),
            const SizedBox(
              height: 12,
            ),
            TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  hintText: 'r/Community_name',
                  contentPadding: EdgeInsets.all(18)),
              maxLength: 21,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              controller: _textController,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(communityControllerProvider.notifier)
                    .createCommunity(name: _textController.text.trim())
                    .run();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Text(
                'Create community',
                style: TextStyle(fontSize: 17),
              ),
            )
          ],
        ),
      ))),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
