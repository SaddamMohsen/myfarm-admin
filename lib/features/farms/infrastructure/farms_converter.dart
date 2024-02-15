import 'package:myfarmadmin/features/farms/domain/entities/farm_entity.dart';

class FarmDataConverter {
  static List<FarmEntity> farmtoList(dynamic data) {
    print(data);
    return (data as List<dynamic>)
        .map((e) => FarmEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
