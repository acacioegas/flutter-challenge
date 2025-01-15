import 'package:challenge_tractian_mobile/pages/assets/assets_page.dart';
import 'package:challenge_tractian_mobile/pages/menu/menu_app_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MenuAppPage(),
    routes: <String, WidgetBuilder> {
      '/assets': (BuildContext context) => AssetsPage(),
    }
  ));
}