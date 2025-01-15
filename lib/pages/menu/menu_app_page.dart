import 'package:challenge_tractian_mobile/models/companie.dart';
import 'package:challenge_tractian_mobile/pages/menu/menu_app_controller.dart';
import 'package:flutter/material.dart';

class MenuAppPage extends StatefulWidget {
  @override
  _MenuAppPageState createState() => _MenuAppPageState();
}

class _MenuAppPageState extends State<MenuAppPage> {
  late StatesMenu state;
  late MenuAppController controller;
  List companies = [];

  @override
  void initState() {
    controller = MenuAppController(stateUpdate: updateState);
    
    controller.loadCompanies();
    super.initState();
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
        backgroundColor: Color(0xff17192D),
        title: Center(
          child: Text("TRACTIAN",
            style: TextStyle(
          color: Colors.white)),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, '/assets',arguments: Companie(controller.companies[index]['id'])),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) => Colors.blue,),
              shape: WidgetStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(0) ))),
            child: Text(controller.companies[index]['name'] + ' Unit')),
        ),
        itemCount: controller.companies.length
        )
    );
  }
}