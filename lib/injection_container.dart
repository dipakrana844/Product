import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'core/navigation/app_router.dart';
import 'core/navigation/navigation_service.dart';
import 'core/navigation/navigation_service_impl.dart';
import 'core/network/dio_factory.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/verify_signup_usecase.dart';
import 'features/auth/domain/usecases/create_organization_usecase.dart';
import 'features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'features/auth/domain/usecases/verify_password_reset_usecase.dart';
import 'features/auth/domain/usecases/complete_password_reset_usecase.dart';
import 'features/auth/domain/usecases/login_with_otp_usecase.dart';
import 'features/auth/domain/usecases/verify_login_otp_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/organization/data/datasources/organization_remote_datasource.dart';
import 'features/organization/data/repositories/organization_repository_impl.dart';
import 'features/organization/domain/repositories/organization_repository.dart';
import 'features/organization/domain/usecases/organization_usecases.dart'
    as org_uc;
import 'features/organization/presentation/bloc/organization_bloc.dart';

import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';
import 'core/network/network_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginWithPassword: sl(),
      signup: sl(),
      verifySignup: sl(),
      createOrganization: sl(),
      requestPasswordReset: sl(),
      verifyPasswordReset: sl(),
      completePasswordReset: sl(),
      loginWithOtp: sl(),
      verifyLoginOtp: sl(),
      tokenStorage: sl(),
      getCurrentUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginWithPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => VerifySignupUseCase(sl()));
  sl.registerLazySingleton(() => CreateOrganizationUseCase(sl()));
  sl.registerLazySingleton(() => RequestPasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => VerifyPasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => CompletePasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyLoginOtpUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl(), tokenStorage: sl()),
  );

  //! Features - Organization
  // Bloc
  sl.registerFactory(
    () => OrganizationBloc(
      getOrganizations: sl(),
      createOrganization: sl(),
      updateOrganization: sl(),
      deleteOrganization: sl(),
      switchOrganization: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => org_uc.GetOrganizationsUseCase(sl()));
  sl.registerLazySingleton(() => org_uc.CreateOrganizationUseCase(sl()));
  sl.registerLazySingleton(() => org_uc.UpdateOrganizationUseCase(sl()));
  sl.registerLazySingleton(() => org_uc.DeleteOrganizationUseCase(sl()));
  sl.registerLazySingleton(() => org_uc.SwitchOrganizationUseCase(sl()));

  // Repository
  sl.registerLazySingleton<OrganizationRepository>(
    () =>
        OrganizationRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
  );

  // Data sources
  sl.registerLazySingleton<OrganizationRemoteDataSource>(
    () => OrganizationRemoteDataSourceImpl(sl()),
  );

  //! Core
  // Navigation
  sl.registerLazySingleton(() => AppRouter(sl()));
  sl.registerLazySingleton<NavigationService>(
    () => NavigationServiceImpl(sl<AppRouter>().createRouter()),
  );

  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton(() => TokenStorage(sl()));

  //! Network
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl(), sl()));
  sl.registerLazySingleton(() => NetworkCubit(sl<NetworkInfo>()));

  //! External
  sl.registerLazySingleton(() => DioFactory.create(sl()));
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
