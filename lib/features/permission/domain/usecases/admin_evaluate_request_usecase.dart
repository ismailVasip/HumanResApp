import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/permission/domain/repo/admin_permission_repo.dart';

class AdminEvaluateRequestUsecase implements Usecase<Either<String,Unit>,AdminEvaluateRequestParams>{
  final AdminPermissionRepo _repo;

  AdminEvaluateRequestUsecase({required AdminPermissionRepo repo}) : _repo = repo;
  @override
  Future<Either<String, Unit>> call(AdminEvaluateRequestParams param) async{
    return await _repo.evaluateRequest(param.isAccepted, param.requestId);
  }
}

class AdminEvaluateRequestParams{
  final bool isAccepted;
  final String requestId;

  AdminEvaluateRequestParams({required this.isAccepted, required this.requestId});
}