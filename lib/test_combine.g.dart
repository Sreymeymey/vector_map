// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_combine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property()
  ..provinceEg = json['province_name'] as String?
  ..provinceKh = json['province_kh'] as String?;

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'province_name': instance.provinceEg,
      'province_kh': instance.provinceKh,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry()
  ..type = json['type'] as String?
  ..coordinates = Geometry._parseCoordinates(json['coordinates'] as List?);

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

MapModel _$MapModelFromJson(Map<String, dynamic> json) => MapModel()
  ..id = json['id'] as String?
  ..dataView = json['dataView'] as int?
  ..featureType = json['type'] as String?
  ..property = json['properties'] == null
      ? null
      : Property.fromJson(json['properties'] as Map<String, dynamic>)
  ..geometry = json['geometry'] == null
      ? null
      : Geometry.fromJson(json['geometry'] as Map<String, dynamic>)
  ..apiId = json['api_id'] as String?;

Map<String, dynamic> _$MapModelToJson(MapModel instance) => <String, dynamic>{
      'id': instance.id,
      'dataView': instance.dataView,
      'type': instance.featureType,
      'properties': instance.property,
      'geometry': instance.geometry,
      'api_id': instance.apiId,
    };
