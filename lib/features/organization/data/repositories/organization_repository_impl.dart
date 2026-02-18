import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../datasources/organization_remote_datasource.dart';
import '../../domain/entities/organization.dart';
import '../../domain/repositories/organization_repository.dart';
import '../models/organization_model.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  final OrganizationRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  OrganizationRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, List<Organization>>> getOrganizations() async {
    try {
      final organizations = await remoteDataSource.getOrganizations();
      return Right(organizations);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Organization>> getOrganizationDetails(
    String id,
  ) async {
    try {
      final organization = await remoteDataSource.getOrganizationDetails(id);
      return Right(organization);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Organization>> createOrganization(
    Organization organization,
  ) async {
    try {
      final model = OrganizationModel(
        id: organization.id,
        name: organization.name,
        email: organization.email,
        phone: organization.phone,
        address: organization.address,
        city: organization.city,
        state: organization.state,
        zipCode: organization.zipCode,
        country: organization.country,
        website: organization.website,
        logo: organization.logo,
        team_size: organization.team_size,
        description: organization.description,
      );
      final createdOrganization = await remoteDataSource.createOrganization(
        model,
      );
      return Right(createdOrganization);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Organization>> updateOrganization(
    String id,
    Organization organization,
  ) async {
    try {
      final model = OrganizationModel(
        id: organization.id,
        name: organization.name,
        email: organization.email,
        phone: organization.phone,
        address: organization.address,
        city: organization.city,
        state: organization.state,
        zipCode: organization.zipCode,
        country: organization.country,
        website: organization.website,
        logo: organization.logo,
        team_size: organization.team_size,
        description: organization.description,
      );
      final updatedOrganization = await remoteDataSource.updateOrganization(
        id,
        model,
      );
      return Right(updatedOrganization);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrganization(String id) async {
    try {
      await remoteDataSource.deleteOrganization(id);
      return const Right(null);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> switchOrganization(String id) async {
    try {
      final response = await remoteDataSource.switchOrganization(id);

      // Save new tokens
      final accessToken = response['access_token'];
      if (accessToken != null) {
        await tokenStorage.saveToken(accessToken.toString());
      }

      final refreshToken = response['refresh_token'];
      if (refreshToken != null) {
        await tokenStorage.saveRefreshToken(refreshToken.toString());
      }

      return const Right(null);
    } on OnboardingRequiredException catch (e) {
      return Left(OnboardingFailure(e.message, e.step));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
