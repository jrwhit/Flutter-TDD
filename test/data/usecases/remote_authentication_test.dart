import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

import 'package:for_dev/data/http/http.dart';
import 'package:for_dev/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthentication systemUniteTest;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    systemUniteTest = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });
  test("should call httpClient with correct url", () async {
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

  test(
    "should throw UnexpectedError if httpclient return 400",
    () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.badRequest);

      final future = systemUniteTest.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "should throw UnexpectedError if httpclient return 404",
        () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed("body"),
        ),
      ).thenThrow(HttpError.notFound);

      final future = systemUniteTest.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
