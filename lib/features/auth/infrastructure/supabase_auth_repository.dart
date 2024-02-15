import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:myfarmadmin/features/auth/domain/entities/user.dart';
import 'package:myfarmadmin/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//import '../models/user.dart';

class SupabaseAuthRepository extends AuthRepository {
  SupabaseAuthRepository({required this.authClient}) : super(authClient);

  /// Exposes Supabase auth client to allow Auth Controller to subscribe to auth changes
  @override
  final GoTrueClient authClient;
  @override
  UserEntity? get currentUser => authClient.currentUser == null
      ? null
      : UserEntity.fromJson(authClient.currentUser!.toJson());

  @override
  Session? get currentSession => authClient.currentSession;
  //
  Stream<AuthState> get authState => authClient.onAuthStateChange;

  Future<User?> restoreSession() async {
    final response =
        await authClient.recoverSession(currentSession!.accessToken.toString());
    final user = response.user;
    //print(user);
    return user;
  }

  @override
  Future<UserEntity?> signInEmailPassword(String email, String password) async {
    // dynamic res = 'no user';
    UserEntity user;
    try {
      user = await authClient
          .signInWithPassword(email: email, password: password)
          .then((value) => UserEntity.fromJson(value.user!.toJson()));

      //return user;
      if (user.userMetadata!['role'] == 'admin')
        return user;
      else
        throw AuthException('You are not admin');
    } on AuthException catch (e) {
      //print(e.message);
      throw PostgrestException(message: e.message);
    } catch (e) {
      throw AuthException(e.toString());

      //rethrow;
    }
  }

  @override
  Future<String> signUpEmailAndPassword(String email, String password) {
    // TODO: implement signUpEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    try {
      await authClient.signOut(scope: SignOutScope.global);
    } catch (e) {
      throw e.toString();
    }
    //throw UnimplementedError();
  }
}
