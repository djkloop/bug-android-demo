import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:one_app/model/home/home_model.dart';

const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';

// 首页接口
class HomeDao {
  static Future<HomeModel> fetch() async {
    final response = await http.get(HOME_URL);
    if (response.statusCode == 200) {
      // 修复中文乱码
      Utf8Decoder utf8encoder = Utf8Decoder();
      var result = json.decode(utf8encoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    } else {
      throw Exception('Failed to head load home_page.json');
    }
  }
}