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

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed("body"),
        ),
      );

  void httpData(Map<String, dynamic> data) {
    mockRequest().thenAnswer(
      (_) async => data,
    );
  }

  void httpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

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
    httpData({
      "accessToken": faker.guid.guid(),
      "name": faker.person.name(),
    });

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
      httpError(HttpError.badRequest);

      final future = systemUniteTest.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "should throw UnexpectedError if httpclient return 404",
    () async {
      httpError(HttpError.notFound);

      final future = systemUniteTest.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "should throw UnexpectedError if httpclient return 500",
    () async {
      httpError(HttpError.serverError);

      final future = systemUniteTest.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "should throw InvalidCredentialsError if httpclient return 401",
    () async {
      httpError(HttpError.unauthorized);

      final future = systemUniteTest.auth(params);

      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    "should return an Account if httpclient return 200",
    () async {
      final accessToken = faker.guid.guid();

      httpData({
        "accessToken": accessToken,
        "name": faker.person.name(),
      });

      final account = await systemUniteTest.auth(params);

      expect(account.token, accessToken);
    },
  );

  test(
    "should throw UnexpectedError if httpclient return 200 with invalid data",
    () async {
      httpData({
        'invalid_key': 'invalid_value',
      });

      final future = systemUniteTest.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
