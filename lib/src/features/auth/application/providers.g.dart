// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userNotifierHash() => r'e41515de9d9f235e21cc739cb0fd9f1af3fb09c6';

/// See also [UserNotifier].
@ProviderFor(UserNotifier)
final userNotifierProvider =
    AutoDisposeNotifierProvider<UserNotifier, UserModel?>.internal(
  UserNotifier.new,
  name: r'userNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserNotifier = AutoDisposeNotifier<UserModel?>;
String _$iAuthRepositoryHash() => r'5fbb1e888777d39ab7d20c20cc295d57bfd09fc5';

/// See also [iAuthRepository].
@ProviderFor(iAuthRepository)
final iAuthRepositoryProvider = AutoDisposeProvider<IAuthRepository>.internal(
  iAuthRepository,
  name: r'iAuthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$iAuthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IAuthRepositoryRef = AutoDisposeProviderRef<IAuthRepository>;
String _$remoteAuthRepositoryHash() =>
    r'a62003151103e7b0f0de33263900c361e67aabe0';

/// See also [remoteAuthRepository].
@ProviderFor(remoteAuthRepository)
final remoteAuthRepositoryProvider =
    AutoDisposeProvider<HttpAuthRepository>.internal(
  remoteAuthRepository,
  name: r'remoteAuthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteAuthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RemoteAuthRepositoryRef = AutoDisposeProviderRef<HttpAuthRepository>;
String _$authServiceHash() => r'f41e0a81ed6b7f38cf63086db8a87793d2f1da58';

/// See also [authService].
@ProviderFor(authService)
final authServiceProvider = AutoDisposeProvider<AuthService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthServiceRef = AutoDisposeProviderRef<AuthService>;
String _$triggerAuthCheckHash() => r'323fa54d6e7b3a7a5de6b62046876f23b2c5615b';

/// See also [triggerAuthCheck].
@ProviderFor(triggerAuthCheck)
final triggerAuthCheckProvider = AutoDisposeFutureProvider<void>.internal(
  triggerAuthCheck,
  name: r'triggerAuthCheckProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$triggerAuthCheckHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TriggerAuthCheckRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
