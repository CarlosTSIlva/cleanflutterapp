import 'package:cleanflutterapp/data/http/htpp.dart';
import 'package:cleanflutterapp/data/usecases/usecases.dart';
import 'package:cleanflutterapp/domain/helpers/helper.dart';
import 'package:cleanflutterapp/domain/usecases/usecases.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClienteSpy extends Mock implements HttpClient {}

void main() {
  HttpClient httpClient;
  String url;
  RemoteAuthentication sut;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClienteSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test(
    "Should call httpClient with correct values",
    () async {
      await sut.auth(params);

      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {
            'email': params.email,
            'password': params.secret,
          },
        ),
      );
    },
  );

  test(
    "Should throw unexpectedError if httpCLient returns 400",
    () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.badRequest);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "Should throw unexpectedError if httpCLient returns 404",
    () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.notFound);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "Should throw unexpectedError if httpCLient returns 500",
    () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.serverError);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    "Should throw invalidCredentialsError if httpCLient returns 401",
    () async {
      when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      ).thenThrow(HttpError.unauthorized);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );
}