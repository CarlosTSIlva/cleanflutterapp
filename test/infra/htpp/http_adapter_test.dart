import 'package:cleanflutterapp/data/http/http_error.dart';
import 'package:cleanflutterapp/infra/http/http.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  ClientSpy? client;
  HttpAdapter? sut;
  String? url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client!);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test(
      'should throw server error if invalid mehos is provider',
      () async {
        final future = sut!.request(url: url!, method: 'invalid method');

        expect(future, throwsA(HttpError.serverError));
      },
    );
  });

  group('post', () {
    PostExpectation mockRequest() => when(client!
        .post(null, headers: anyNamed('headers'), body: anyNamed('body')));

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
      'should call post with correct values',
      () async {
        await sut!
            .request(url: url!, method: 'post', body: {"any_key": "any_value"});

        verify(
          client!.post(
            Uri.parse(
              url!,
            ),
            headers: {
              'Content-Type': 'application/json',
              'accept': 'application/json'
            },
            body: '{"any_key":"any_value"}',
          ),
        );
      },
    );
    test(
      'should call post with without body',
      () async {
        await sut!.request(url: url!, method: 'post');

        verify(
          client!.post(
            any,
            headers: anyNamed('headers'),
          ),
        );
      },
    );

    test(
      'should return data if post returns 200',
      () async {
        final response = await sut!.request(url: url!, method: 'post');
        expect(response, {"any_key": "any_value"});
      },
    );

    test(
      'should return null if post returns 200 with no data',
      () async {
        mockResponse(200, body: '');
        final response = await sut!.request(url: url!, method: 'post');
        expect(response, null);
      },
    );

    test(
      'should return null if post returns 204',
      () async {
        mockResponse(204, body: '');
        final response = await sut!.request(url: url!, method: 'post');
        expect(response, null);
      },
    );

    test(
      'should return null if post returns 204 with data',
      () async {
        mockResponse(204);
        final response = await sut!.request(url: url!, method: 'post');
        expect(response, null);
      },
    );

    test(
      'should return badRequestError if post returns 400',
      () async {
        mockResponse(400);
        final future = sut!.request(url: url!, method: 'post');
        expect(future, throwsA(HttpError.badRequest));
      },
    );
    test(
      'should return badRequestError if post returns 400',
      () async {
        mockResponse(400, body: '');
        final future = sut!.request(url: url!, method: 'post');
        expect(future, throwsA(HttpError.badRequest));
      },
    );

    test(
      'should return UnauthorizeError if post returns 401',
      () async {
        mockResponse(401, body: '');
        final future = sut!.request(url: url!, method: 'post');
        expect(future, throwsA(HttpError.unauthorized));
      },
    );

    test(
      'should return Forbidden if post returns 403',
      () async {
        mockResponse(403);
        final future = sut!.request(url: url!, method: 'post');
        expect(future, throwsA(HttpError.forbidden));
      },
    );

    test(
      'should return not Found if post returns 404',
      () async {
        mockResponse(404);
        final future = sut!.request(url: url!, method: 'post');
        expect(future, throwsA(HttpError.notFound));
      },
    );

    test(
      'should return not Found if post returns throws',
      () async {
        mockError();
        final future = sut!.request(url: url!, method: 'post');
        expect(future, throwsA(HttpError.serverError));
      },
    );
  });
}
