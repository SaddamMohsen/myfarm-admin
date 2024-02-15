import 'package:freezed_annotation/freezed_annotation.dart';

part 'farm_entity.freezed.dart';
part 'farm_entity.g.dart';

/// farm entity
@freezed
class FarmEntity with _$FarmEntity {
  @JsonSerializable(fieldRename: FieldRename.snake)

  /// Factory Constructor
  const factory FarmEntity({
    required int id,
    required String farm_name,
    required String farm_type,
    required bool is_running,
    required int no_of_ambers,
    // ignore: invalid_annotation_target
    @JsonKey(includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) DateTime? farm_start_date,
    @JsonKey(includeIfNull: false) DateTime? farm_end_date,
    String? farm_supervisor,
    String? role,
  }) = _FarmEntity;

  /// factory method to create entity from JSON
  factory FarmEntity.fromJson(Map<String, dynamic> json) =>
      _$FarmEntityFromJson(json);
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
