import 'package:json_annotation/json_annotation.dart';
part 'model_api.g.dart';

@JsonSerializable()
class MapApi {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "dataView")
  int? dataView;

  MapApi();
  factory MapApi.fromJson(Map<String, dynamic> json) => _$MapApiFromJson(json);

  Map<String, dynamic> toJson() => _$MapApiToJson(this);

  @override
  String toString() {
    return 'MapApiModel{id: $id, budget: $dataView}';
  }
}
