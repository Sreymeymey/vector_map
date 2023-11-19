// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_local.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapLocal _$MapLocalFromJson(Map<String, dynamic> json) => MapLocal()
  ..typeFeature = json['type'] as String?
  ..id = json['id'] as String?
  ..provinceKh = json['province_kh'] as String?
  ..provinceEn = json['province_name'] as String?
  ..coordinates = (json['coordinates'] as List<dynamic>?)
      ?.map((e) => (e as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList())
      .toList();

Map<String, dynamic> _$MapLocalToJson(MapLocal instance) => <String, dynamic>{
      'type': instance.typeFeature,
      'id': instance.id,
      'province_kh': instance.provinceKh,
      'province_name': instance.provinceEn,
      'coordinates': instance.coordinates,
    };
