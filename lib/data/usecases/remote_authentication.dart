import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/entities/entities.dart';
import '../../data/models/models.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<AccountEntity> auth (AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromAuthenticationParams(params).toJson();
    try{
      final response = await httpClient.request(url: url, method: "post", body: body);
      return RemoteAccountModel.fromJson(response).toAccountEntity();
    } on HttpError catch(error){
      switch(error){
        case HttpError.badRequest:
        case HttpError.notFound:
        case HttpError.serverError:
        case HttpError.invalidData:
          throw DomainError.unexpected;
          break;
        case HttpError.unauthorized:
          throw DomainError.invalidCredentials;
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
