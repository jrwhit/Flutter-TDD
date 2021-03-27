import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/http/http_client.dart';

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

    return response.body.isEmpty ? null : jsonDecode(response.body);
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

  group(
    "post",
    () {
      PostExpectation mockRequest() => when(client.post(any,
          body: anyNamed('body'), headers: anyNamed('headers')));

      void mockResponse(int statusCode,
          {String body = '{"any_key":"any_value"}'}) {
        mockRequest().thenAnswer((_) async => Response(body, statusCode));
      }

      setUp(() {
        mockResponse(200);
      });
      test(
        'should call post with correct value',
        () async {
          await systemUniteTest.request(
              url: url, method: "post", body: {'any_key': 'any_value'});

          verify(
            client.post(
              url,
              headers: {
                'content-type': 'application/json',
                'accept': 'application/json',
              },
              body: '{"any_key":"any_value"}',
            ),
          );
        },
      );

      test(
        'should call post without body',
        () async {
          await systemUniteTest.request(
            url: url,
            method: "post",
          );

          verify(
            client.post(any, headers: anyNamed('headers')),
          );
        },
      );

      test(
        'should call return data if post return 200',
        () async {
          final response =
              await systemUniteTest.request(url: url, method: "post");

          expect(response, {'any_key': 'any_value'});
        },
      );

      test(
        'should call return null if post return 200 with no data',
        () async {
          mockResponse(200, body: '');

          final response =
              await systemUniteTest.request(url: url, method: "post");

          expect(response, null);
        },
      );

      test(
        'should call return null if post return 204',
            () async {
          mockResponse(204, body: '');

          final response =
          await systemUniteTest.request(url: url, method: "post");

          expect(response, null);
        },
      );
    },
  );
}