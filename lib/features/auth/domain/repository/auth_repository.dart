import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfarmadmin/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  const AuthRepository(this.authClient);
  final GoTrueClient authClient;
  Session? get currentSession => authClient.currentSession;
  UserEntity? get currentUser => authClient.currentUser == null
      ? null
      : UserEntity.fromJson(authClient.currentUser!.toJson());
  Future<UserEntity?> signInEmailPassword(String email, String password);
  Future<String> signUpEmailAndPassword(String email, String password);
  
  Future<void> signOut();
}
