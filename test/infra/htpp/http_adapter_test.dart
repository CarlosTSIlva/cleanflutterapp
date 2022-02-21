import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class ClientSpy extends Mock implements Client {}

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json'
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    await client.post(Uri.parse(url), headers: headers, body: jsonBody);
  }
}

void main() {
  ClientSpy client;
  HttpAdapter sut;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    test(
      'should call post with correct values',
      () async {
        await sut
            .request(url: url, method: 'post', body: {"any_key": "any_value"});

        verify(
          client.post(
            Uri.parse(
              url,
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
        await sut.request(url: url, method: 'post');

        verify(
          client.post(
            any,
            headers: anyNamed('headers'),
          ),
        );
      },
    );
  });
}
