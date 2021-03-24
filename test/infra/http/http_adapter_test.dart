import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  Map<String, dynamic> body;

  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    @required String url,
    @required String method,
    Map<String, dynamic> body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'aplication/json',
    };
    await client.post(url, headers: headers, body: body != null ? jsonEncode(body) : null);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter systemUniteTest;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    systemUniteTest = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group("post", () {
    test('should call post with correct value', () async {
      await systemUniteTest
          .request(url: url, method: "post", body: {'any_key': 'any_value'});

      verify(
        client.post(url,
            headers: {
              'content-type': 'application/json',
              'accept': 'aplication/json',
            },
            body: '{"any_key":"any_value"}'),
      );
    });

    test('should call post without body', () async {
      await systemUniteTest.request(url: url, method: "post");

      verify(
        client.post(
          url,
          headers: {
            'content-type': 'application/json',
            'accept': 'aplication/json',
          },
        ),
      );
    });
  });
}
