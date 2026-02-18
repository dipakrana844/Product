import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/organization.dart';

abstract class OrganizationRepository {
  Future<Either<Failure, List<Organization>>> getOrganizations();
  Future<Either<Failure, Organization>> getOrganizationDetails(String id);
  Future<Either<Failure, Organization>> createOrganization(
    Organization organization,
  );
  Future<Either<Failure, Organization>> updateOrganization(
    String id,
    Organization organization,
  );
  Future<Either<Failure, void>> deleteOrganization(String id);
  Future<Either<Failure, void>> switchOrganization(String id);
}
