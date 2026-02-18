import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CompletePasswordResetUseCase
    implements UseCase<void, CompletePasswordResetParams> {
  final AuthRepository repository;

  CompletePasswordResetUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CompletePasswordResetParams params) async {
    return await repository.completePasswordReset(
      params.email,
      params.resetToken,
      params.newPassword,
    );
  }
}

class CompletePasswordResetParams extends Equatable {
  final String email;
  final String resetToken;
  final String newPassword;

  const CompletePasswordResetParams({
    required this.email,
    required this.resetToken,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, resetToken, newPassword];
}
