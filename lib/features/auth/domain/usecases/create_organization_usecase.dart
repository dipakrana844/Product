import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CreateOrganizationUseCase
    implements UseCase<void, CreateOrganizationParams> {
  final AuthRepository repository;

  CreateOrganizationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateOrganizationParams params) async {
    return await repository.createOrganization(params.organizationData);
  }
}

class CreateOrganizationParams {
  final Map<String, dynamic> organizationData;

  const CreateOrganizationParams({required this.organizationData});
}
