import 'package:meta/meta.dart';

import '../../usecases/authentication.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth(AuthenticationParams params) async {
    var body = RemoteAuthenticationParams.fromAuthenticationParams(params).toJson();
    await httpClient.request(url: url, method: "post", body: body);
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
