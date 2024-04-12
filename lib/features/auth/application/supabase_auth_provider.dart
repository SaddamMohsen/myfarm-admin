import 'package:myfarmadmin/features/auth/domain/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfarmadmin/features/auth/infrastructure/supabase_auth_repository.dart';
import 'package:myfarmadmin/config/provider.dart';

part 'supabase_auth_provider.g.dart';

@riverpod
SupabaseAuthRepository supabaseAuthRep(SupabaseAuthRepRef ref) {
  final authClient = ref.watch(supabaseClientProvider).auth;
  return SupabaseAuthRepository(authClient: authClient);
}

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // return const SignInState.canSubmit();
  }
  // FutureOr<User?> build() async {
  //   final repository = ref.watch(supaAuthRepProvider).currentUser;
  //   //final res = await repository.restoreSession();
  //   final userEntity = repository; //..fold((l) => null, (r) => r);
  //   //_updateAuthState(userEntity);
  //   if (userEntity?.id == null) print('no user');

  //   /// try to create session from deep link
  //   //await _handleInitialDeepLink();
  //   return userEntity;
  // }

  /// listen to auth changes
  //   repository.authStateChang((user) {
  //     state = AsyncData(user);
  //     _updateAuthState(userEntity);
  //   });
  //   return userEntity;
  //   // TODO(vh): how to cancel subscription override dispose
  // }

  // void _updateAuthState(User? userEntity) {
  //   authState.value = userEntity != null;
  // }

  Future<bool> login(String email, String password) async {
    final repository = ref.read(supabaseAuthRepProvider);
    state = const AsyncValue.loading();
    //print('state1 :$state');
    state = await AsyncValue.guard(
        () => repository.signInEmailPassword(email, password));
    //print('state2 :$state');
    return state.hasError == true;
  }

  ///
  ///get the curernt session
  Future<bool> currentSession() async {
    final repository = ref.read(supabaseAuthRepProvider).currentSession;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => Future(() => repository?.accessToken));
    //return state.asData?.value ;
    return state.hasError == false;
  }

  ///get the current logged in user
  Future<UserEntity?> currentUser() async {
    final repository = ref.read(supabaseAuthRepProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => Future.value(repository.currentUser));
    return repository.currentUser;
  }

  Future<bool> signOut() async {
    final repository = ref.read(supabaseAuthRepProvider);
    state = await AsyncValue.guard(() => repository.signOut());

    return state.hasError == false;
    // state = const AsyncValue.loading();
    // state = await AsyncValue.guard(() =>);
  }
}
