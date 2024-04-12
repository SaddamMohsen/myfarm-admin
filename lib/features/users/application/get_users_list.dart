import 'package:myfarmadmin/config/provider.dart';
import 'package:myfarmadmin/features/auth/domain/entities/user.dart';
import 'package:myfarmadmin/features/users/infrastructure/supabase_user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/supabase_auth_provider.dart';

part 'get_users_list.g.dart';

final userRepositoryProvider = Provider.autoDispose((ref) {
  final user = ref.watch(supabaseAuthRepProvider.select((v) => v.currentUser));
  if (user == null) throw AssertionError('لم تقم بتسجيل الدخول');

  return SupabaseUserRepository(
      supabaseClient: ref.watch(supabaseClientProvider), user: user);
});

@riverpod
Future<List<UserEntity>> getUsersList(GetUsersListRef ref) async {
  final repository = ref.watch(userRepositoryProvider);

  return repository.getUsers();
}
