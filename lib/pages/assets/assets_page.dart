import 'package:challenge_tractian_mobile/models/companie.dart';
import 'package:challenge_tractian_mobile/pages/assets/assets_controller.dart';
import 'package:challenge_tractian_mobile/pages/assets/widgets/tree_optimazed_widget.dart';
import 'package:flutter/material.dart';

enum AssetsOptions {
  sensordeenergia,
  critico
}

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  late StatesAssets state;
  late AssetsController controller;
  late Companie companie;
  List<(AssetsOptions,IconData, String)> assetsOptions = <(AssetsOptions,IconData, String)>[
    (AssetsOptions.sensordeenergia,Icons.bolt, 'Sensor de Energia'),
    (AssetsOptions.critico, Icons.priority_high, 'Crítico'),
  ];
  Set<AssetsOptions> segmentedButtonSelection = <AssetsOptions>{};
  String filter = '';

  @override
  void initState() {
    controller = AssetsController(stateUpdate: updateState);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      companie = ModalRoute.of(context)!.settings.arguments as Companie;
      controller.loadLocationAndAssetsByCompanie(companie.id);
    });
  }

  void updateState() {

    setState(() {
      state = controller.state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        backgroundColor: Color(0xff17192D),
        title: Center(
          child: Text("Assets",
            style: TextStyle(
          color: Colors.white)),
        ),
      ),
      body: Column(
        children: [
          Container(   
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent)
            ),
            child: TextField(
              onChanged: (value) => setState(() {
                filter = value;
              }),
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                fillColor: Colors.amberAccent,
                labelText: "Buscar Ativo ou Local",
              ),
            ),
          ),
          SegmentedButton<AssetsOptions>(
            multiSelectionEnabled: true,
            emptySelectionAllowed: true,
            showSelectedIcon: true,
            selected: segmentedButtonSelection,
            onSelectionChanged: (Set<AssetsOptions> newSelection){
              setState(() {
                segmentedButtonSelection = newSelection;
              });
            },
            segments: assetsOptions.map<ButtonSegment<AssetsOptions>>(((AssetsOptions,IconData, String) options) {
              return ButtonSegment<AssetsOptions>(value: options.$1,label: Row(children: [Icon(options.$2) ,Text(options.$3)]));
            }).toList(),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView(
                  children: [
                    TreeOptimazed(
                      treeList: controller.treeLocationAndAssets,
                      segmentedButtonSelection: segmentedButtonSelection,
                      controller: controller,
                      filter: filter,
                      ),
                  ]
                ),
                Visibility(
                  visible: controller.state == StatesAssets.loading,
                  child: CircularProgressIndicator(),)
                  
              ],
            ),
          )
        ],
      )
    );
  }
}