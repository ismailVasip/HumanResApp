part of 'service_locator.dart';

final serviceLocator = GetIt.instance;

void setUpServiceLocator() {
  //Service
  serviceLocator.registerSingleton<FirebaseAuthDatasource>(
    FirebaseAuthDatasourceImp(),
  );
  serviceLocator.registerSingleton<FirebaseRoleDatasource>(
    FirebaseRoleDatasourceImp(),
  );
  serviceLocator.registerSingleton<AdminAssetmngDatasrc>(
    AdminAssetManagmentImp(),
  );
  serviceLocator.registerSingleton<UserAssetmngDatasrc>(
    UserAssetmngDatasrcImp(),
  );
  serviceLocator.registerSingleton<CreateAdminDatasrc>(CreateAdminDatasrcImp());
  serviceLocator.registerSingleton<UserPermissionDatasource>(
    UserPermissionDatasourceImp(),
  );
  serviceLocator.registerSingleton<AdminPermissionDatasource>(
    AdminPermissionDatasourceImp(),
  );
  serviceLocator.registerSingleton<CreateCompanyPolicyDatasrc>(
    CreateCompanyPolicyDatasrcImp(),
  );
  serviceLocator.registerSingleton<AdminMainPageDatasource>(
    AdminMainPageDatasourceImp(),
  );
  serviceLocator.registerSingleton<AdvanceRequestDatasource>(
    AdvanceRequestDatasourceImp(),
  );
  serviceLocator.registerSingleton<CompanyPolicyDatasource>(
    CompanyPolicyDatasourceImp(),
  );
  serviceLocator.registerSingleton<UserFinancialsDatasource>(
    UserFinancialsDatasourceImp(),
  );

  //Repositories
  serviceLocator.registerSingleton<AuthRepo>(
    AuthRepoImp(datasource: serviceLocator()),
  );
  serviceLocator.registerSingleton<GetRoleRepo>(GetRoleRepoImp());
  serviceLocator.registerSingleton<AdminAssetmngRepo>(
    AdminAssetmngRepoImp(remoteDataSource: serviceLocator()),
  );
  serviceLocator.registerSingleton<UserAssetmngRepo>(
    UserAssetmngRepoImp(datasrc: serviceLocator()),
  );
  serviceLocator.registerSingleton<CreateAdminRepo>(
    CreateAdminRepoImp(datasrc: serviceLocator()),
  );
  serviceLocator.registerSingleton<UserPermissionRepo>(
    UserPermissionRepoImp(datasource: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminPermissionRepo>(
    AdminPermissionRepoImp(datasource: serviceLocator()),
  );
  serviceLocator.registerSingleton<CreateCompanyPolicyRepo>(
    CreateCompanyPolicyRepoImp(datasrc: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminMainPageRepo>(
    AdminMainPageRepoImp(datasource: serviceLocator()),
  );
  serviceLocator.registerSingleton<UserFinancialsRepo>(
    UserFinancialsRepoImp(datasource: serviceLocator()),
  );
  serviceLocator.registerSingleton<CompanyPolicyRepo>(
    CompanyPolicyRepoImp(datasource: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdvanceRequestRepo>(
    AdvanceRequestRepoImp(datasource: serviceLocator()),
  );

  //Usecases
  serviceLocator.registerSingleton<SignUpUseCase>(SignUpUseCase());
  serviceLocator.registerSingleton<SignInUseCase>(SignInUseCase());
  serviceLocator.registerSingleton<GetRoleUsecase>(GetRoleUsecase());

  serviceLocator.registerSingleton<AdminAssignassetUsecase>(
    AdminAssignassetUsecase(repo: serviceLocator(), authRepo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminCancelAssignUsecase>(
    AdminCancelAssignUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminGetAssetsUsecase>(
    AdminGetAssetsUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<UserGetAssetsUsecase>(
    UserGetAssetsUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AuthStateChangeUsecase>(
    AuthStateChangeUsecase(authRepo: serviceLocator()),
  );
  serviceLocator.registerSingleton<LogOutUsecase>(
    LogOutUsecase(authRepo: serviceLocator()),
  );
  serviceLocator.registerSingleton<CreateAdminUsecase>(
    CreateAdminUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<MatchAdminAndUserUsecase>(
    MatchAdminAndUserUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<GetMyPermissionsUsecase>(
    GetMyPermissionsUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AskPermissionUsecase>(
    AskPermissionUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminGetAllPermissionsUsecase>(
    AdminGetAllPermissionsUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminEvaluateRequestUsecase>(
    AdminEvaluateRequestUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<CreateCompanyPolicyUsecase>(
    CreateCompanyPolicyUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminGetUserUsecase>(
    AdminGetUserUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminUpdateAnnualLimitUsecase>(
    AdminUpdateAnnualLimitUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<GetUserFinancialsUsecase>(
    GetUserFinancialsUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<GetCompanyPolicyUsecase>(
    GetCompanyPolicyUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<GetAdminAdvanceReqUsecase>(
    GetAdminAdvanceReqUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<GetUserAdvanceReqUsecase>(
    GetUserAdvanceReqUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<CreateAdvanceReqUsecase>(
    CreateAdvanceReqUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<UpdateReqStatusUsecase>(
    UpdateReqStatusUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminGetAllUsersUsecase>(
    AdminGetAllUsersUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<UserSendReqSupportLine>(
    UserSendReqSupportLine(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminGetSupportLineReqUsecase>(
    AdminGetSupportLineReqUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<AdminCreateAnnouncementUsecase>(
    AdminCreateAnnouncementUsecase(repo: serviceLocator()),
  );
  serviceLocator.registerSingleton<GetAllAnnouncementsUsecase>(
    GetAllAnnouncementsUsecase(repo: serviceLocator()),
  );

  //bloc
  serviceLocator.registerFactory(
    () => AuthBloc(
      signInUseCase: serviceLocator(),
      signUpUseCase: serviceLocator(),
      logOutUsecase: serviceLocator(),
      authStateChangeUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => RoleCubit(getRoleUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => AssetsMngBloc(
      adminAssignassetUsecase: serviceLocator(),
      adminCancelAssignUsecase: serviceLocator(),
      adminGetAssetsUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserAssetsMngBloc(
      userGetAssetsUsecase: serviceLocator(),
      reqSupportLine: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => CreateAdminBloc(
      createAdminUsecase: serviceLocator(),
      matchAdminAndUserUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => PermissionBloc(
      getMyPermissionUsecase: serviceLocator(),
      askPermissionUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => AdminPermissionBloc(
      adminGetAllPermissionsUsecase: serviceLocator(),
      adminEvaluateRequestUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => CreatePolicyBloc(createCompanyPolicyUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => AdminMainPageBloc(
      adminGetUserUsecase: serviceLocator(),
      adminUpdateFinancialsUsecase: serviceLocator(),
      adminGetAllUsersUsecase: serviceLocator(),
      adminGetSupportLineReqUsecase: serviceLocator(),
      adminCreateAnnouncementUsecase: serviceLocator(),
      getAllAnnouncementsUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserBonusBloc(
      createAdvanceReqUsecase: serviceLocator(),
      getCompanyPolicyUsecase: serviceLocator(),
      getUserAdvanceReqUsecase: serviceLocator(),
      getUserFinancialsUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => AdminBonusBloc(
      updateReqStatusUsecase: serviceLocator(),
      getPendingReqUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserMainBloc(
      getAllAnnouncementsUsecase: serviceLocator()
    ),
  );
}
