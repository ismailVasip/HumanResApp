import 'package:ikproject/core/usecase/usecase.dart';
import 'package:ikproject/features/auth/domain/repo/auth_repo.dart';

class LogOutUsecase implements Usecase<void,NoParamsForLogout>{
  final AuthRepo _authRepo;

  LogOutUsecase({required AuthRepo authRepo}) : _authRepo = authRepo;
  @override
  Future<void> call(NoParamsForLogout param) async{
    return  _authRepo.signOut();
  }
}

class NoParamsForLogout{}