import 'package:myfarmadmin/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getUsers();
  Future<UserEntity> createNewUser(UserEntity newUser);
}
