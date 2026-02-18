import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';
import '../entities/auth_result.dart';

class VerifySignupUseCase implements UseCase<AuthResult, VerifyParams> {
  final AuthRepository repository;

  VerifySignupUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResult>> call(VerifyParams params) async {
    return await repository.verifySignup(params.type, params.code);
  }
}

class VerifyParams {
  final String type;
  final String code;
  const VerifyParams(this.type, this.code);
}
