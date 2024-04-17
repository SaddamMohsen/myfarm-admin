import 'package:myfarmadmin/config/provider.dart';
import 'package:myfarmadmin/features/farms/domain/entities/farm_entity.dart';
import 'package:myfarmadmin/features/farms/infrastructure/supabase_farm_repository.dart';
import 'package:myfarmadmin/features/auth/application/supabase_auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_farm.g.dart';

final farmRepositoryProvider = Provider.autoDispose((ref) {
  final user = ref.watch(supabaseAuthRepProvider.select((v) => v.currentUser));
  if (user == null) throw AssertionError('لم تقم بتسجيل الدخول');

  return SupabaseFarmRepository(
      supabaseClient: ref.watch(supabaseClientProvider), user: user);
});

@riverpod
Future<void> createFarm(CreateFarmRef ref,
    {required FarmEntity newFarm}) async {
  final repository = ref.watch(farmRepositoryProvider);

  return repository.createNewFarm(newFarm);
}
