import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

enum StatesAssets {
  initial,
  loading,
  loaded
}

class AssetsController {
  final Function stateUpdate;
  StatesAssets state = StatesAssets.initial;
  List treeLocationAndAssets = [];
  List assets = [];
  List locations = [];

  AssetsController({required this.stateUpdate});

  Future<void> loadLocationAndAssetsByCompanie(String companie) async {
    state = StatesAssets.loading;
    stateUpdate.call();

    assets = await _loadAssetsByCompanie(companie);
    locations = await _loadLocationsByCompanie(companie);

    treeLocationAndAssets = loadTreeNode({'id': null});

    // treeLocationAndAssets = _mergeEntity(locations, assets, 'id', 'locationId');

    state = StatesAssets.loaded;
    stateUpdate.call();
    
  }

  Future<List> _loadAssetsByCompanie(String companie) async {
    var url =
      Uri.https('fake-api.tractian.com', '/companies/$companie/assets');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200){ 
      return _loadTree(convert.jsonDecode(response.body) as List);
    }

    return [];
  }

  Future<List> _loadLocationsByCompanie(String companie) async {
    var url =
      Uri.https('fake-api.tractian.com', '/companies/$companie/locations');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200){ 
      return _loadTree(convert.jsonDecode(response.body) as List);
    }

    return [];
  }

  List _loadTree(List list){

    return list;

    // TENTATIVA 1
    // List backupLisp = list;
    // list.map((x) {
    //       var children = backupLisp.where((y) => y['parentId']==x['id']);
    //       if (children.isNotEmpty)
    //       {
    //         if (x['children'] is! List) x['children'] = [];
    //         if (x['expanded'] is! bool) x['expanded'] = false;
    //         for (var y in children) {
    //           (x['children'] as List).add(y);
    //         }
    //       }
    //       }).toList();
    //   list.removeWhere((e) => e['parentId']!=null);
    //   return list;
  }

List loadTreeNode(Map node){
    
    List children = [];

    var foundAssets = assets.where((iMap) => (node['id']!=null) && (iMap['parentId']==node['id']) || (!node.containsKey('sensorId') && iMap['locationId']==node['id']));
    for (var iMap in foundAssets) {
      iMap['hasChildren'] = assets.where((iMapSub) => iMapSub['parentId']==iMap['id']).isNotEmpty;
      if (iMap['children'] is! List) iMap['children'] = [];
      if (iMap['expanded'] is! bool) iMap['expanded'] = false;
      children.add(iMap);
    }
    assets.removeWhere((iMap) => (node['id']!=null) && (iMap['parentId']==node['id']) || (!node.containsKey('sensorId') && iMap['locationId']==node['id']));

    if (!node.containsKey('sensorId')){
      var foundLocations = locations.where((iMap) => iMap['parentId']==node['id']);
      for (var iMap in foundLocations) {
        iMap['hasChildren'] = locations.where((iMapSub) => iMapSub['parentId']==iMap['id']).isNotEmpty || assets.where((iMapSub) => iMapSub['locationId']==iMap['id']).isNotEmpty ;
        if (iMap['children'] is! List) iMap['children'] = [];
        if (iMap['expanded'] is! bool) iMap['expanded'] = false;
        children.add(iMap);
      }
      locations.removeWhere((iMap) => iMap['parentId']==node['id']);
    }
    children.sort((a,b) => (a['id'] as String).compareTo(b['id']));
    return children;
    
  }

  List _mergeEntity(List listA, List listB, String fieldAMatch,String fieldBMatch){
    
    print('inicio do merge');

    listA.map((iMap) {
      var listFould = listB.where((iSearch) => iSearch[fieldBMatch]==iMap[fieldAMatch]);
      if (listFould.isNotEmpty) {
        if (iMap['children'] is! List) iMap['children'] = [];
        if (iMap['expanded'] is! bool) iMap['expanded'] = false;
        for (var i in listFould) {
          (iMap['children'] as List).add(i);
        }
        listB.removeWhere((iSearch) => iSearch[fieldBMatch]==iMap[fieldAMatch]);
      }
    }).toList();

    for (var iMap in listB) {
      listA.add(iMap);
    }
    return listA;
  }
}