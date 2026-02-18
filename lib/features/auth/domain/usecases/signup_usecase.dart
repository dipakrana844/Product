import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_result.dart';
import '../entities/signup_params.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase implements UseCase<AuthResult, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResult>> call(SignupParams params) async {
    return await repository.signup(params);
  }
}
