import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/auth_result.dart';
import '../entities/signup_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> signup(SignupParams signupParams);
  Future<Either<Failure, AuthResult>> verifySignup(String type, String code);
  Future<Either<Failure, void>> createOrganization(Map<String, dynamic> data);

  Future<Either<Failure, AuthResult>> loginWithPassword(
    String email,
    String password,
  );
  Future<Either<Failure, void>> loginWithOtp(String phone);
  Future<Either<Failure, AuthResult>> verifyLoginOtp(String phone, String otp);

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> requestPasswordReset(String email);
  Future<Either<Failure, String>> verifyPasswordReset(
    String email,
    String code,
  );
  Future<Either<Failure, void>> completePasswordReset(
    String email,
    String token,
    String newPassword,
  );
}
