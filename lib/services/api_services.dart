import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ghazal_model.dart';

class ApiService {
  static const String _base = 'https://api.ganjoor.net';
  final http.Client _client = http.Client();

  Future<Ghazal> fetchGhazalById(String id) async {
    final url = Uri.parse('$_base/api/ganjoor/poem/$id?verseDetails=true');

    final response = await _client
        .get(url, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Ghazal.fromDetailJson(data);
    }

    throw Exception('Failed: ${response.statusCode}');
  }
}
