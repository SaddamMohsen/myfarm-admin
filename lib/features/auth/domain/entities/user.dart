import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Auth user entity
@freezed
class UserEntity with _$UserEntity {
  @JsonSerializable(fieldRename: FieldRename.snake)

  /// Factory Constructor
  const factory UserEntity({
    required String id,
    required String email,
    required String phone,
    // ignore: invalid_annotation_target
    @JsonKey(includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) DateTime? updatedAt,
    @JsonKey(includeIfNull: false) DateTime? emailConfirmedAt,
    @JsonKey(includeIfNull: false) DateTime? phoneConfirmedAt,
    @JsonKey(includeIfNull: false) DateTime? lastSignInAt,
    @JsonKey(includeIfNull: false) Map<String, dynamic>? userMetadata,
    String? role,
  }) = _UserEntity;

  /// factory method to create entity from JSON
  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}







// class AppUser {
//   final int uuid;
//   final String? name;
//   final String email;
//   final String schema;
//   const AppUser(
//       {required this.uuid,
//       required this.name,
//       required this.email,
//       required this.schema});

//   factory AppUser.fromJson(Map<String, dynamic> json) {
//     return AppUser(
//       uuid: json['uid'],
//       name: json['name'],
//       email: json['email'],
//       schema: json['role'],
//     );
//   }
// }
