import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/organization.dart';
import '../repositories/organization_repository.dart';

class GetOrganizationsUseCase implements UseCase<List<Organization>, NoParams> {
  final OrganizationRepository repository;

  GetOrganizationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Organization>>> call(NoParams params) async {
    return await repository.getOrganizations();
  }
}

class GetOrganizationDetailsUseCase implements UseCase<Organization, String> {
  final OrganizationRepository repository;

  GetOrganizationDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, Organization>> call(String id) async {
    return await repository.getOrganizationDetails(id);
  }
}

class CreateOrganizationUseCase implements UseCase<Organization, Organization> {
  final OrganizationRepository repository;

  CreateOrganizationUseCase(this.repository);

  @override
  Future<Either<Failure, Organization>> call(Organization organization) async {
    return await repository.createOrganization(organization);
  }
}

class UpdateOrganizationUseCase
    implements UseCase<Organization, UpdateOrganizationParams> {
  final OrganizationRepository repository;

  UpdateOrganizationUseCase(this.repository);

  @override
  Future<Either<Failure, Organization>> call(
    UpdateOrganizationParams params,
  ) async {
    return await repository.updateOrganization(params.id, params.organization);
  }
}

class UpdateOrganizationParams {
  final String id;
  final Organization organization;

  UpdateOrganizationParams(this.id, this.organization);
}

class DeleteOrganizationUseCase implements UseCase<void, String> {
  final OrganizationRepository repository;

  DeleteOrganizationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteOrganization(id);
  }
}

class SwitchOrganizationUseCase implements UseCase<void, String> {
  final OrganizationRepository repository;

  SwitchOrganizationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.switchOrganization(id);
  }
}
