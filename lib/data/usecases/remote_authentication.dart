import 'package:meta/meta.dart';

import '../../domain/usecases/authentication.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  // ignore: missing_return
  Future<AccountEntity> auth (AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromAuthenticationParams(params).toJson();
    try{
      final response = await httpClient.request(url: url, method: "post", body: body);
      return AccountEntity.fromJson(response);
    } on HttpError catch(error){
      switch(error){
        case HttpError.badRequest:
        case HttpError.notFound:
        case HttpError.serverError:
          throw DomainError.unexpected;
          break;
        case HttpError.unauthorized:
          return throw DomainError.invalidCredentials;
          break;
      }
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password,
  });

  factory RemoteAuthenticationParams.fromAuthenticationParams(
          AuthenticationParams params) =>
      RemoteAuthenticationParams(
          email: params.email, password: params.password);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
