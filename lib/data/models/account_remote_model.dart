import 'package:for_dev/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel(this.token);

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) =>
  RemoteAccountModel(json['accessToken']);

  AccountEntity toAccountEntity () => AccountEntity(token);
}