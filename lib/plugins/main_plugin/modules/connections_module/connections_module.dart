import '../../../00_base/module_base.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConnectionsModule extends ModuleBase {
  final String baseUrl;

  ConnectionsModule._internal(this.baseUrl) {
    _registerConnectionMethods();
  }

  /// Factory method to create an instance with the specified baseUrl
  factory ConnectionsModule(String baseUrl) {
    return ConnectionsModule._internal(baseUrl);
  }

  /// Registers methods with the module
  void _registerConnectionMethods() {
    registerMethod('sendGetRequest', sendGetRequest);
    registerMethod('sendPostRequest', sendPostRequest);
    registerMethod('sendRequest', sendRequest);
  }

  /// Validates URLs
  void validateUrl(String url) {
    if (!Uri.tryParse(url)!.isAbsolute ?? true) {
      throw Exception('Invalid URL: $url');
    }
  }

  /// Method to handle GET requests
  Future<dynamic> sendGetRequest(String route) async {
    final url = Uri.parse('$baseUrl$route');
    validateUrl(url.toString());

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print('GET $url - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return {"message": "GET request failed", "error": e.toString()};
    }
  }

  /// Method to handle POST requests
  Future<dynamic> sendPostRequest(String route, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$route');
    validateUrl(url.toString());

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print('POST $url - Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return {"message": "POST request failed", "error": e.toString()};
    }
  }

  /// Flexible method to handle various HTTP methods
  Future<dynamic> sendRequest(
      String route, {
        required String method,
        Map<String, dynamic>? data,
      }) async {
    final url = Uri.parse('$baseUrl$route');
    validateUrl(url.toString());

    try {
      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: {"Content-Type": "application/json"});
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data ?? {}),
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data ?? {}),
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: {"Content-Type": "application/json"});
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      print('$method $url - Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return {"message": "$method request failed", "error": e.toString()};
    }
  }
}
