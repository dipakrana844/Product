import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginWithOtpUseCase implements UseCase<void, String> {
  final AuthRepository repository;

  LoginWithOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String phone) async {
    return await repository.loginWithOtp(phone);
  }
}
