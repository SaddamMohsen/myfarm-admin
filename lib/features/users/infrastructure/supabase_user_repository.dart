import 'package:myfarmadmin/features/auth/domain/entities/user.dart';

import 'package:myfarmadmin/features/users/domain/user_repository.dart';
import 'package:myfarmadmin/features/users/infrastructure/users_converter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUserRepository implements UserRepository {
  const SupabaseUserRepository(
      {required this.supabaseClient, required this.user})
      : super();
  final SupabaseClient supabaseClient;
  final UserEntity user;
  @override
  Future<List<UserEntity>> getUsers() async {
    String schema = user.userMetadata?['schema'] ?? 'public';
    String? role = user.userMetadata?['user_schema'] ?? 'authenticated';

    List<UserEntity> users = [];
    try {
      users = await supabaseClient
          //.useSchema(schema)
          .rpc('retieve_users_in_schema', params: {
            'schema_name': schema,
            'user_role': role,
          })
          .select()
          .withConverter<List<UserEntity>>(
              (data) => UsersDataConverter.usertoList(data));
      print(users);
      return users;
    } on PostgrestException catch (e) {
      throw e.message.toString();
    }
  }

  ///add new User
  @override
  Future<String> createNewUser(UserEntity newUser) async {
    // TODO: implement createNewUser
    String schema = user.userMetadata?['schema'] ?? 'public';
    String? role = user.userMetadata?['user_schema'] ?? 'authenticated';

    try {
      await supabaseClient
          //.useSchema(schema)
          .rpc('create_user', params: {
        'email': newUser.email,
        'password': newUser.password,
        'user_meta': {"schema": schema},
        'schema_user_name': role,
        'schema_name': schema,
      });

      return 'success';
    } on PostgrestException catch (e) {
      throw e.message.toString();
    }
    //throw UnimplementedError();
  }
}
