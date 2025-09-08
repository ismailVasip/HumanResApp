import 'package:dartz/dartz.dart';
import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/main_page/domain/repo/admin_main_page_repo.dart';

class AdminUpdateAnnualLimitUsecase
    implements Usecase<Either<String, Unit>, UpdateUserFinancialsParams> {
  final AdminMainPageRepo _repo;

  AdminUpdateAnnualLimitUsecase({required AdminMainPageRepo repo})
    : _repo = repo;
  @override
  Future<Either<String, Unit>> call(UpdateUserFinancialsParams param) async {
    return await _repo.updateUserFinancials(
      param.userEmail,
      param.newAnnualLimit,
    );
  }
}

class UpdateUserFinancialsParams {
  final String userEmail;
  final double newAnnualLimit;

  UpdateUserFinancialsParams({
    required this.userEmail,
    required this.newAnnualLimit,
  });
}
