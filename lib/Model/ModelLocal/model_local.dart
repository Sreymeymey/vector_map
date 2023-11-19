

/// this class model not work when get load asset data
// import 'package:json_annotation/json_annotation.dart';
// part 'model_local.g.dart';
//
// @JsonSerializable()
// class MapLocal {
//   @JsonKey(name: "type")
//   String? type;
//
//   @JsonKey(name: "id")
//   String? id;
//
//   @JsonKey(name: "properties")
//   Properties? properties;
//
//   @JsonKey(name: "geometry")
//   Geometry? geometry;
//
//   MapLocal();
//   factory MapLocal.fromJson(Map<String, dynamic> json) => _$MapLocalFromJson(json);
//   Map<String, dynamic> toJson() => _$MapLocalToJson(this);
// }
//
// @JsonSerializable()
// class Properties {
//   @JsonKey(name: "province_name")
//   String? provinceEn;
//
//   @JsonKey(name: "adm1_altnm")
//   String? provinceKh;
//
//   Properties();
//   factory Properties.fromJson(Map<String, dynamic> json) => _$PropertiesFromJson(json);
//   Map<String, dynamic> toJson() => _$PropertiesToJson(this);
// }
//
// @JsonSerializable()
// class Geometry {
//   @JsonKey(name: "type")
//   String? type;
//
//   @JsonKey(name: "coordinates")
//   List<List<List<double>>>? coordinates;
//
//   Geometry();
//   factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);
//   Map<String, dynamic> toJson() => _$GeometryToJson(this);
// }
import 'package:json_annotation/json_annotation.dart';
part 'model_local.g.dart';

@JsonSerializable()
class MapLocal {

  @JsonKey(name: "type")
  String? typeFeature;

  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "province_kh")
  String? provinceKh;

  @JsonKey(name: "province_name")
  String? provinceEn;

  @JsonKey(name: "coordinates")
  List<List<List<double>>>? coordinates;

  MapLocal();
  factory MapLocal.fromJson(Map<String, dynamic> json) => _$MapLocalFromJson(json);

  Map<String, dynamic> toJson() => _$MapLocalToJson(this);
  @override
  String toString() {
    return 'MapLocalModel{typeFeature: $typeFeature, id: $id, provinceKh: $provinceKh, provinceEn: $provinceEn, coordinates: $coordinates}';
  }
}