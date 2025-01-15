import 'package:challenge_tractian_mobile/pages/assets/assets_controller.dart';
import 'package:challenge_tractian_mobile/pages/assets/assets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TreeOptimazed extends StatefulWidget{
  TreeOptimazed({super.key, required List treeList, required this.segmentedButtonSelection, required this.controller, required this.filter}){
    internaltreeList = treeList;
  }
  List? internaltreeList;
  AssetsController controller;
  Set<AssetsOptions> segmentedButtonSelection;
  String filter;

  @override
  _TreeOptimazedState createState() => _TreeOptimazedState();

}



class _TreeOptimazedState extends State<TreeOptimazed> {
  
  
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.internaltreeList!.where((node) => (node['name'] as String).toUpperCase().contains(widget.filter.toUpperCase()) || !(node as Map).containsKey('locationId')).toList().map<Widget>((node) {
        if (node['hasChildren'] == true ){
          return Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if ((node['children'] as List).isEmpty) node['children'] = widget.controller.loadTreeNode(node);
                    
                    setState(() {
                    node['expanded'] = !node['expanded'];
                    });
                  },
                  child: Row(
                    children: [
                      (node['expanded']) ? Icon(Icons.keyboard_arrow_down,color: Colors.grey) : Icon(Icons.keyboard_arrow_right,color: Colors.grey),
                      (node.containsKey('locationId')) ? ImageIcon(AssetImage('assets/component.png'),size: 24,color: Colors.blue) : Icon(Icons.location_on,color: Colors.blue),
                      Text((node['name'] as String).toUpperCase())
                    ],
                  ),
                ),
                Row(children: [
                  SizedBox(width: 24,),
                  (node['expanded']) ? TreeOptimazed(treeList: node['children'],segmentedButtonSelection: widget.segmentedButtonSelection,controller: widget.controller,filter: widget.filter,) : SizedBox(width: 5,)
                ],)

              ],
          );
        }
        return (widget.segmentedButtonSelection.contains(AssetsOptions.critico) && node['status']=='alert') ||
                (widget.segmentedButtonSelection.contains(AssetsOptions.sensordeenergia) && node['sensorType']=='energy') ||
                widget.segmentedButtonSelection.isEmpty

               ? Row(
                  children: [
                    SizedBox(width: 24,),
                    (node.containsKey('sensorType')) ? ImageIcon(AssetImage('assets/asset.png'),size: 24,color: Colors.blue) : Icon(Icons.location_on,color: Colors.blue,),
                    Text((node['name'] as String).toUpperCase()),
                    (node.containsKey('sensorType')) ? Icon( (node['sensorType']=='energy') ? Icons.bolt : Icons.circle ,color: (node['status']=='alert') ? Colors.red : Colors.green,) : SizedBox()
                  ],
                ) : SizedBox(width: 5,);

      }).toList(),
    ); 
  }
}