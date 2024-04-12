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
    print(schema);
    //schema = schema.substring(0, 10);
    print(schema);
    List<FarmEntity> farms = [];
    try {
      farms = await supabaseClient
          .useSchema(schema)
          .from('farms')
          .select()
          .withConverter<List<FarmEntity>>(
              (data) => FarmDataConverter.farmtoList(data));
      print(farms);
      return farms;
    } on PostgrestException catch (e) {
      throw e.message.toString();
    }
  }

  ///add new farm
  @override
  Future<FarmEntity> createNewFarm(FarmEntity newFarm) {
    // TODO: implement createNewFarm
    throw UnimplementedError();
  }
}

@override
Future<FarmEntity> createNewFarm(FarmEntity farm) {
  throw UnimplementedError();
}
