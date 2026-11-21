import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat_image.dart';

class CatApi {
  static const String _baseUrl = 'https://api.thecatapi.com/v1/images/search';

  Future<List<CatImage>> fetchCatImages({int limit = 10}) async {
    final uri = Uri.parse('$_baseUrl?limit=$limit');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CatImage.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки: ${response.statusCode}');
    }
  }
}