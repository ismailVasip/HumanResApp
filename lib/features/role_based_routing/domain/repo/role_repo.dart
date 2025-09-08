import 'package:dartz/dartz.dart';

abstract interface class GetRoleRepo{
  Future<Either<String,(String,String?)>> getCurrentUserRole();
}