import 'package:myfarmadmin/features/auth/domain/entities/user.dart';
import 'package:myfarmadmin/features/farms/domain/entities/farm_entity.dart';
import 'package:myfarmadmin/features/farms/domain/repository/farm_repository.dart';
import 'package:myfarmadmin/features/farms/infrastructure/farms_converter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseFarmRepository implements FarmRepository {
  const SupabaseFarmRepository(
      {required this.supabaseClient, required this.user})
      : super();
  final SupabaseClient supabaseClient;
  final UserEntity user;
  @override
  Future<List<FarmEntity>> getFarms() async {
    String schema = user.userMetadata?['schema'] ?? 'public';

    //if (schema != 'public') schema = schema.substring(0, 10);

    List<FarmEntity> farms = [];
    try {
      farms = await supabaseClient
          .useSchema(schema)
          .from('farms')
          .select()
          .withConverter<List<FarmEntity>>(
              (data) => FarmDataConverter.farmtoList(data));

      return farms;
    } on PostgrestException catch (e) {
      throw e.message.toString();
    }
  }

  ///add new farm
  @override
  Future<void> createNewFarm(FarmEntity newFarm) async {
    // TODO: implement createNewFarm
    String schema = user.userMetadata?['schema'] ?? 'public';
    print(schema);
    print({newFarm});
    try {
      await supabaseClient.useSchema(schema).from('farms').insert({
        'farm_name': newFarm.farm_name,
        'farm_type': newFarm.farm_type,
        'farm_supervisor': newFarm.farm_supervisor,
        'no_of_ambers': newFarm.no_of_ambers,
      });
      return;
    } on PostgrestException catch (e) {
      print('postgressException');
      print(e.message);
    } catch (e) {
      print('in creact farm catch');
      print(e.toString());
    }

    throw UnimplementedError();
  }
}
