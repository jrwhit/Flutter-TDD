import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/infra/http/http.dart';
import 'package:for_dev/data/http/http.dart';

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

  group("share", (){

    test(
      'should throw serverError if invalid method is provided',
          () async {
        final future = systemUniteTest.request(url: url, method: "invalid_method");

        expect(future, throwsA(HttpError.serverError));
      },
    );
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

      void mockError() {
        mockRequest().thenThrow(Exception());
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

      test(
        'should call return null if post return 204 with not data',
        () async {
          mockResponse(204);

          final response =
              await systemUniteTest.request(url: url, method: "post");

          expect(response, null);
        },
      );

      test(
        'should call return badRequest if post return 400',
        () async {
          mockResponse(400);

          final future = systemUniteTest.request(url: url, method: "post");

          expect(future, throwsA(HttpError.badRequest));
        },
      );

      test(
        'should call return badRequest if post return 400 without data',
        () async {
          mockResponse(400, body: '');

          final future = systemUniteTest.request(url: url, method: "post");

          expect(future, throwsA(HttpError.badRequest));
        },
      );

      test(
        'should call return unauthorized if post return 401',
        () async {
          mockResponse(401);

          final future = systemUniteTest.request(url: url, method: "post");

          expect(future, throwsA(HttpError.unauthorized));
        },
      );

      test(
        'should call return forbidden if post return 403',
        () async {
          mockResponse(403);

          final future = systemUniteTest.request(url: url, method: "post");

          expect(future, throwsA(HttpError.forbidden));
        },
      );

      test(
        'should call return Not Found if post return 404',
            () async {
          mockResponse(404);

          final future = systemUniteTest.request(url: url, method: "post");

          expect(future, throwsA(HttpError.notFound));
        },
      );

      test(
        'should call return Server Error if post return 500',
        () async {
          mockResponse(500);

          final future = systemUniteTest.request(url: url, method: "post");

          expect(future, throwsA(HttpError.serverError));
        },
      );

      test(
        'should call return Server Error if post return throws',
            () async {
          mockError();

          final future = systemUniteTest.request(url: url, method: "post");

          expect(future, throwsA(HttpError.serverError));
        },
      );
    },
  );
}
