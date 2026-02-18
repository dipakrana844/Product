import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/signup_params.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, AuthResult>> signup(SignupParams signupParams) async {
    try {
      final authResponse = await remoteDataSource.signup(signupParams.toMap());

      if (authResponse.accessToken.isNotEmpty) {
        await tokenStorage.saveToken(authResponse.accessToken);
      }

      if (authResponse.userId.isNotEmpty) {
        await tokenStorage.saveUserId(authResponse.userId);
      }

      return Right(authResponse);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> verifySignup(
    String type,
    String code,
  ) async {
    try {
      final authResult = await remoteDataSource.verifySignup(type, code);

      
      if (authResult.accessToken.isNotEmpty) {
        await tokenStorage.saveToken(authResult.accessToken);
      }

      if (authResult.userId.isNotEmpty) {
        await tokenStorage.saveUserId(authResult.userId);
      }

      return Right(authResult);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createOrganization(
    Map<String, dynamic> data,
  ) async {
    try {
      await remoteDataSource.createOrganization(data);
      return const Right(null);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> loginWithPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await remoteDataSource.loginWithPassword(
        email,
        password,
      );

      final authResult = AuthResponseModel.fromJson(response);

      
      if (authResult.accessToken.isNotEmpty) {
        await tokenStorage.saveToken(authResult.accessToken);
      }
      final refreshToken = response['refresh_token'];
      if (refreshToken != null) {
        await tokenStorage.saveRefreshToken(refreshToken.toString());
      }

      
      final userId = authResult.userId;
      if (userId.isNotEmpty) {
        await tokenStorage.saveUserId(userId);
      }

      
      if (!authResult.phoneVerified) {
        return const Left(
          VerificationRequiredFailure('Phone verification required', 'phone'),
        );
      }
      if (!authResult.emailVerified) {
        return const Left(
          VerificationRequiredFailure('Email verification required', 'email'),
        );
      }

      final onboarding = authResult.onboardingStatus.toUpperCase();
      if (onboarding == 'PENDING' || onboarding == 'INCOMPLETE') {
        return const Left(
          OnboardingFailure(
            'Please complete organization setup',
            'CREATE_ORGANIZATION',
          ),
        );
      }

      return Right(authResult);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> loginWithOtp(String phone) async {
    try {
      await remoteDataSource.loginWithOtp(phone);
      return const Right(null);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> verifyLoginOtp(
    String phone,
    String otp,
  ) async {
    try {
      final response = await remoteDataSource.verifyLoginOtp(phone, otp);
      final authResult = AuthResponseModel.fromJson(response);

      
      if (authResult.accessToken.isNotEmpty) {
        await tokenStorage.saveToken(authResult.accessToken);
      }
      final refreshToken = response['refresh_token'];
      if (refreshToken != null) {
        await tokenStorage.saveRefreshToken(refreshToken.toString());
      }

      
      final userId = authResult.userId;
      if (userId.isNotEmpty) {
        await tokenStorage.saveUserId(userId);
      }

      return Right(authResult);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on VerificationRequiredException catch (e) {
      return Left(VerificationRequiredFailure(e.message, e.type));
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    try {
      await remoteDataSource.requestPasswordReset(email);
      return const Right(null);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> verifyPasswordReset(
    String email,
    String code,
  ) async {
    try {
      final token = await remoteDataSource.verifyPasswordReset(email, code);
      return Right(token);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> completePasswordReset(
    String email,
    String token,
    String newPassword,
  ) async {
    try {
      await remoteDataSource.completePasswordReset(email, token, newPassword);
      return const Right(null);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
