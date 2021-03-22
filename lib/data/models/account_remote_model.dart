import '../../data/http/http.dart';
import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String token;

  RemoteAccountModel(this.token);

  factory RemoteAccountModel.fromJson(Map<String, dynamic> json) {
      if(json.containsKey('accessToken')){
        return RemoteAccountModel(json['accessToken']);
      }else{
        throw HttpError.invalidData;
      }
  }

  AccountEntity toAccountEntity () => AccountEntity(token);
}