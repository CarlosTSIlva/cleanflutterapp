import 'package:cleanflutterapp/data/http/htpp.dart';
import 'package:cleanflutterapp/data/usecases/usecases.dart';
import 'package:cleanflutterapp/domain/usecases/usecases.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClienteSpy extends Mock implements HttpClient {}

void main() {
  HttpClient httpClient;
  String url;
  RemoteAuthentication sut;

  setUp(() {
    httpClient = HttpClienteSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
  });

  test(
    "Should call httpCliente with correct url",
    () async {
      final params = AuthenticationParams(
          email: faker.internet.email(), secret: faker.internet.password());

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
}
