import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyPasswordResetUseCase
    implements UseCase<String, VerifyPasswordResetParams> {
  final AuthRepository repository;

  VerifyPasswordResetUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyPasswordResetParams params) async {
    return await repository.verifyPasswordReset(params.email, params.code);
  }
}

class VerifyPasswordResetParams extends Equatable {
  final String email;
  final String code;

  const VerifyPasswordResetParams({required this.email, required this.code});

  @override
  List<Object?> get props => [email, code];
}
