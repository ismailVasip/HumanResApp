import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';
import 'package:ikproject/features/asset_managment/domain/repo/user_assetmng_repo.dart';

class UserSendReqSupportLine
    implements Usecase<Either<String, Unit>, SupportLineEntity> {
  final UserAssetmngRepo _repo;

  UserSendReqSupportLine({required UserAssetmngRepo repo}) : _repo = repo;
  @override
  Future<Either<String, Unit>> call(SupportLineEntity param) async {
    return await _repo.sendReqToSupportLine(param);
  }
}
