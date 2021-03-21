import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/domain/data/http/http.dart';
import 'package:for_dev/domain/data/usecases/usecases.dart';

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
