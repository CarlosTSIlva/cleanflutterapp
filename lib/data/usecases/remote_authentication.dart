import 'package:cleanflutterapp/data/models/models.dart';
import 'package:cleanflutterapp/domain/entities/account_entity.dart';
import 'package:meta/meta.dart';

import 'package:cleanflutterapp/domain/helpers/helper.dart';
import 'package:cleanflutterapp/domain/usecases/usecases.dart';
import '../http/htpp.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;
  RemoteAuthenticationParams({@required this.email, @required this.password});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) {
    return RemoteAuthenticationParams(
        email: entity.email, password: entity.secret);
  }

  Map toJson() => {
        'email': email,
        'password': password,
      };
}
