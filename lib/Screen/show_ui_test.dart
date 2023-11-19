import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vector_map/map/vector_map.dart';

class ExampleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExampleState();
}

class ExampleState extends State<ExampleWidget> {
  VectorMapController? _controller;
  MapDebugger debugger = MapDebugger();

  @override
  void initState() {
    super.initState();
    _loadDataSources();
  }

  void _loadDataSources() async {
    String geoJson = await rootBundle.loadString('assets/cambodiamap.json');
    MapDataSource ds = await MapDataSource.geoJson(geoJson: geoJson,keys: ['adm1_name'],labelKey: 'adm1_altnm');
    MapLayer layer = MapLayer(
      dataSource: ds,
      theme: MapValueTheme(
          contourColor: Colors.white,
          labelVisibility: (feature) => true,
          key: 'adm1_name',
          colors: {
            'Banteay Meanchey': Colors.green,
            'Battambang': Colors.red,
            'Kampong Cham': Colors.orange,
            'Kampong Chhnang': Colors.blue,
            'Kampong Speu': Colors.green,
            'Kampong Thom': Colors.red,
            'Kampot': Colors.orange,
            'Kandal': Colors.blue,
            'Kep': Colors.orange,
            'Koh Kong': Colors.blue,
            'Kratie': Colors.green,
            'Mondul Kiri': Colors.red,
            'Oddar Meanchey': Colors.orange,
            'Kampong Chhnang': Colors.blue,
            'Banteay Meanchey': Colors.green,
            'Battambang': Colors.red,
            'Kampong Cham': Colors.orange,
            'Kampong Chhnang': Colors.blue,
            'Kampong Cham': Colors.orange,
            'Kampong Chhnang': Colors.blue,
            'Battambang': Colors.red,
            'Kampong Cham': Colors.orange,
            'Kampong Chhnang': Colors.blue,
            'Kampong Cham': Colors.orange,
            'Kampong Chhnang': Colors.blue,

          }),
      highlightTheme: MapHighlightTheme(color: Colors.green[900]!),
    );

    setState(() {
      _controller = VectorMapController(layers: [layer], delayToRefreshResolution: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? content;
    if (_controller != null) {
      VectorMap map = VectorMap(
        controller: _controller,
        clickListener: (feature) => print(feature.id),
      );
      Widget buttons = SingleChildScrollView(
          child: Row(children: [
            _buildFitButton(),
            SizedBox(width: 8),
            _buildModeButton(),
            SizedBox(width: 8),
            _buildZoomInButton(),
            SizedBox(width: 8),
            _buildZoomOutButton()
          ]));

      Widget buttonsAndMap = Column(children: [
        Padding(child: buttons, padding: EdgeInsets.only(bottom: 8)),
        Expanded(child: map)
      ]);

      content = buttonsAndMap;
      /*
      content = Row(children: [
        Expanded(child: buttonsAndMap),
        SizedBox(
            child: Padding(
                child: MapDebuggerWidget(debugger),
                padding: EdgeInsets.all(16)),
            width: 200)
      ]);

       */
    } else {
      content = Center(child: Text('Loading...'));
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white!),
        home: Scaffold(
            body: SafeArea(
                child: Padding(child: content, padding: EdgeInsets.all(8)))));

  }

  Widget _buildFitButton() {
    return ElevatedButton(child: Text('Fit'), onPressed: _onFit);
  }

  void _onFit() {
    _controller?.fit();
  }

  Widget _buildModeButton() {
    return ElevatedButton(child: Text('Change mode'), onPressed: _onMode);
  }

  void _onMode() {
    VectorMapMode mode = _controller!.mode == VectorMapMode.autoFit ? VectorMapMode.panAndZoom : VectorMapMode.autoFit;
    _controller!.mode = mode;
  }

  Widget _buildZoomInButton() {
    return ElevatedButton(child: Text('Zoom in'), onPressed: _onZoomIn);
  }

  void _onZoomIn() {
    _controller!.zoomOnCenter(true);
  }

  Widget _buildZoomOutButton() {
    return ElevatedButton(child: Text('Zoom out'), onPressed: _onZoomOut);
  }

  void _onZoomOut() {
    _controller!.zoomOnCenter(false);
  }
}