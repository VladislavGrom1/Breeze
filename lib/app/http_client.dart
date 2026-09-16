import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  final _httpClient = http.Client();

  HttpClient();

  Future<Map<String, dynamic>> getData(Uri uri) async {
    try {
      final response = await _httpClient.get(uri);
      return _decode(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> postData(Uri uri, {Map<String, dynamic>? body}) async {
    try {
      final response = await _httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      );
      return _decode(response);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteData(Uri uri) async {
    try {
      final response = await _httpClient.delete(uri);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Exception ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode != 200 && response.statusCode != 201) {
      String detail = response.body;
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['detail'] != null) {
          detail = decoded['detail'].toString();
        }
      } catch (_) {

      }
      throw Exception('Exception ${response.statusCode}: $detail');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is List) {
      return {'items': decoded};
    }
    return decoded as Map<String, dynamic>;
  }

  void close() => _httpClient.close();
}