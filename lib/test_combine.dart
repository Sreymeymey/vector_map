import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_map/Model/ModelApi/model_api.dart';
import 'package:vector_map/Model/ModelLocal/model_local.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: dataLocal(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              var items = data.data as List<MapLocal>;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text('${items[index].id}'),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));

        }


  /// Map local
  List<MapLocal>? mapLocalData;

  /// data load year from json asset
  Future<List<MapLocal>> dataLocal() async {
    final jsonString = await rootBundle.loadString('assets/cambodiamap.json');
    final jsonData = jsonDecode(jsonString)['features'] as List<dynamic>;
    mapLocalData = jsonData.map((item) => MapLocal.fromJson(item)).toList(); // Update the dropdown list data
    return mapLocalData!;
  }


  /// Map local
  List<MapApi>? mapApiData;

  /// data load year from json asset
  Future<List<MapApi>> dataAPI() async {
    final jsonString = await rootBundle.loadString('assets/mapData.json');
    final jsonData = jsonDecode(jsonString)['data'] as List<dynamic>;
    mapApiData = jsonData.map((item) => MapApi.fromJson(item))
        .toList(); // Update the dropdown list data
    return mapApiData!;
  }

  /// function combine [MapAPI] and [MapLocal] by id
void _setCombine() async {
  final List<MapLocal> localItems = await dataLocal();
  final List<MapApi> apiItems = await dataAPI();

  for (final localElement in localItems) {
    for (final apiElement in apiItems) {
      if (localElement.id != apiElement.id) {
        apiElement.id = apiElement.id?.replaceAll("R_", "");
        debugPrint(apiElement.id);
      } else {
       // apiItems.addAll(localItems);
      }
    }
  }
}


/// Solution 2
//   void main() {
//     // Sample JSON strings
//     String jsonLocal = '';
//     String jsonApi = '';
//
//     // Parse JSON strings
//     var dataLocal = json.decode(jsonLocal);
//     var dataAPI = json.decode(jsonApi);
//
//     // Compare and merge if necessary
//     if (dataLocal['id'] == dataAPI['id']) {
//       // Merge the contents of json1Data into json2Data
//       dataAPI.addAll(dataLocal);
//
//       print('Merge successful!');
//       print(json.encode(dataLocal));
//     } else {
//       print('ID fields do not match. Merge aborted.');
//     }
//   }


}










