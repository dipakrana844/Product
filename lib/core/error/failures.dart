import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class OnboardingFailure extends Failure {
  final String step;
  const OnboardingFailure(super.message, this.step);

  @override
  List<Object> get props => [message, step];
}

class VerificationRequiredFailure extends Failure {
  final String type; // 'phone' or 'email'
  const VerificationRequiredFailure(super.message, this.type);

  @override
  List<Object> get props => [message, type];
}
