import 'package:myfarmadmin/features/farms/domain/entities/farm_entity.dart';

abstract class FarmRepository {
  Future<List<FarmEntity>> getFarms();
  Future<FarmEntity> createNewFarm(FarmEntity newFarm);
}
