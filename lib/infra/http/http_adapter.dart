import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  Map<String, dynamic> body;

  final Client client;

  HttpAdapter(this.client);

  Future<Map<String, dynamic>> request({
    @required String url,
    @required String method,
    Map<String, dynamic> body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final response = await client.post(url,
        headers: headers, body: body != null ? jsonEncode(body) : null);

    switch(response.statusCode){
      case 200:
        return response.body.isEmpty ? null : jsonDecode(response.body);
        break;
      default:
        return null;
    }
  }
}