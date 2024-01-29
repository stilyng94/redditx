import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_controller.g.dart';

@riverpod
Box<String> themeBox(ThemeBoxRef ref) => throw UnimplementedError();

@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeMode build() {
    return getTheme().run();
  }

  Task<Unit> changeTheme() {
    return Task(() async {
      final currentTheme = ref
          .read(themeBoxProvider)
          .get('theme', defaultValue: ThemeMode.light.name);
      final newMode = currentTheme == ThemeMode.light.name
          ? ThemeMode.dark
          : ThemeMode.light;
      await ref.watch(themeBoxProvider).put('theme', newMode.name);
      state = newMode;
      return unit;
    });
  }

  IO<ThemeMode> getTheme() {
    return IO(() => ref
        .read(themeBoxProvider)
        .get('theme', defaultValue: ThemeMode.light.name)).flatMap(
      (currentTheme) => IO(() => currentTheme == ThemeMode.light.name
          ? ThemeMode.light
          : ThemeMode.dark),
    );
  }
}
