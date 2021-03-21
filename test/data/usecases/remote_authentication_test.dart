import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:meta/meta.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth() async {
    await httpClient.request(url: url, method: "post");
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method,
  });
}

class HttpClientSpy extends Mock implements HttpClient {
  
}

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthentication systemUniteTest;

  setUp((){
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    systemUniteTest =
    RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test("should call httpClient with correct url", () async {

    await systemUniteTest.auth();

    verify(httpClient.request(url: url, method: "post"));
  });
}
