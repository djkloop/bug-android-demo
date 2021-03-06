import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:one_app/model/home/search/search_model.dart';

const url = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=q';

class SearchDao {
  static Future<SearchModel> fetch(String url, String key) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      //
      SearchModel model = SearchModel.formJson(result);
      model.keyword = key;
      return model;
    } else {
      throw Exception('Failed to load with search_dao.json');
    }
  }
}