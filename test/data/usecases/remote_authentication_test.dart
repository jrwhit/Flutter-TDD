import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/domain/usecases/authentication.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth(AuthenticationParams params) async {
    var body = {"email": params.email, "password": params.password};
    await httpClient.request(url: url, method: "post", body: body);
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method,
    Map<String, dynamic> body,
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthentication systemUniteTest;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    systemUniteTest = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test("should call httpClient with correct url", () async {
    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    await systemUniteTest.auth(params);

    verify(
      httpClient.request(
        url: url,
        method: "post",
        body: {
          "email": params.email,
          "password": params.password,
        },
      ),
    );
  });
}
