import 'package:myfarmadmin/features/auth/domain/entities/user.dart';

class UsersDataConverter {
  static List<UserEntity> usertoList(dynamic data) {
    print(data);
    return (data as List<dynamic>)
        .map((e) => UserEntity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
