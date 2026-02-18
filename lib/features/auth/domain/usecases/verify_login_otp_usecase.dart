import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class VerifyLoginOtpUseCase
    implements UseCase<AuthResult, VerifyLoginOtpParams> {
  final AuthRepository repository;

  VerifyLoginOtpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResult>> call(VerifyLoginOtpParams params) async {
    return await repository.verifyLoginOtp(params.phone, params.otp);
  }
}

class VerifyLoginOtpParams extends Equatable {
  final String phone;
  final String otp;

  const VerifyLoginOtpParams({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}
