import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part "test_combine.g.dart";

@JsonSerializable()
class Property {
  @JsonKey(name: "province_name")
  String? provinceEg;

  @JsonKey(name: "province_kh")
  String? provinceKh;

  Property();
  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyToJson(this);

  @override
  String toString() => 'Property(provinceEg: $provinceEg, provinceKh: $provinceKh)';
}

@JsonSerializable()
class Geometry {
  @JsonKey(name: "type")
  String? type;

  @JsonKey(name: "coordinates", fromJson: _parseCoordinates)
  List<List<List<double>>>? coordinates;

  // Parse coordinates, some of them are having incorrect type
  static List<List<List<double>>>? _parseCoordinates(List<dynamic>? coordinates) {
    if (coordinates == null) {
      return null;
    }

    return coordinates.map((e) {
      return (e as List<dynamic>).map((e) {
        return (e as List<dynamic>).map((e) {
          if (e is List<dynamic>) {
            return (e.first as double).toDouble();
          }
          return (e as double).toDouble();
        }).toList();
      }).toList();
    }).toList();
  }

  Geometry();
  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);

  @override
  String toString() {
    return 'Geometry(type: $type, total coordinates: ${coordinates?.length} items)';
  }
}

@JsonSerializable()
class MapModel {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "dataView")
  int? dataView;

  @JsonKey(name: "type")
  String? featureType;

  @JsonKey(name: "properties")
  Property? property;

  @JsonKey(name: "geometry")
  Geometry? geometry;

  @JsonKey(name: "api_id")
  String? apiId;

  MapModel();
  factory MapModel.fromJson(Map<String, dynamic> json) => _$MapModelFromJson(json);

  Map<String, dynamic> toJson() => _$MapModelToJson(this);

  @override
  String toString() {
    // return new line to make it easier to read
    return 'MapModel(\n\tid: $id, \n\tdataView: $dataView, \n\tfeatureType: $featureType, \n\tproperty: $property, \n\tgeometry: $geometry\n)';
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Combine"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<MapModel>>(
        future: loadMapData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(item.id.toString()),
                        Text(item.apiId?.toString() ?? "No Match"),
                        Text(item.dataView?.toString() ?? "No Match"),
                        Text(item.property!.provinceEg.toString()),
                        Text(item.property!.provinceKh.toString()),
                        Text(item.geometry!.type.toString()),
                        if (item.geometry!.coordinates != null)
                          Text("${item.geometry!.coordinates!.length} items"),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            log("Error: ${snapshot.error}", error: snapshot.error);
            return Center(child: Text(snapshot.error.toString(), textAlign: TextAlign.center));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> _loadJsonData(String path, String key) async {
  final raw = await rootBundle.loadString(path);
  final decoded = jsonDecode(raw);
  return (decoded[key] as List<dynamic>).cast<Map<String, dynamic>>();
}

Future<List<MapModel>> loadMapData() async {
  final localItems = await _loadJsonData("assets/cambodiamap.json", "features");
  final apiItems = await _loadJsonData("assets/mapData.json", "data");

  final mergedItems = <Map<String, dynamic>>[];

  // Use local as base
  for (final local in localItems) {
    final id = local["id"];
    final matchedApiById = apiItems.firstWhere(
      (api) {
        final formattedId = api["id"].toString().replaceAll('R_', "").padLeft(2, "0");
        return formattedId == id;
      },
      orElse: () => {},
    );

    mergedItems.add({
      ...local,
      ...matchedApiById
        ..addAll({"api_id": matchedApiById["id"]})
        ..remove("id"),
    });
  }

  return mergedItems.map((e) => MapModel.fromJson(e)).toList();
}
