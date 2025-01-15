import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

enum StatesMenu {
  initial,
  loading,
  loaded
}

class MenuAppController {
  final Function stateUpdate;
  StatesMenu state = StatesMenu.initial;
  List companies = [];

  MenuAppController({required this.stateUpdate});
  Future<List> loadCompanies() async {
    state = StatesMenu.loading;
    stateUpdate.call();
    var url =
      Uri.https('fake-api.tractian.com', '/companies');

    var response = await http.get(url);
    if (response.statusCode == 200){ 
      companies = convert.jsonDecode(response.body) as List;
      state = StatesMenu.loaded;
      stateUpdate.call();
    }
    
    return companies;

    }
}