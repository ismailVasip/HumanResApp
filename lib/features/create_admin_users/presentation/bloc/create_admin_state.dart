part of 'create_admin_bloc.dart';

sealed class CreateAdminState extends Equatable {
  const CreateAdminState();

  @override
  List<Object?> get props => [];
}

final class CreateAdminInitial extends CreateAdminState{}

final class CreateAdminLoading extends CreateAdminState{}
final class MatchAdminAndUserLoading extends CreateAdminState{}

final class CreateAdminFailure extends CreateAdminState{
  final String error;

  const CreateAdminFailure({required this.error});

  @override
  List<Object?> get props =>  [error];
}

final class CreateAdminSuccess extends CreateAdminState{
  
}

final class MatchAdminAndUserSuccess extends CreateAdminState{
  
}