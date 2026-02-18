import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/organization_model.dart';

abstract class OrganizationRemoteDataSource {
  Future<List<OrganizationModel>> getOrganizations();
  Future<OrganizationModel> getOrganizationDetails(String id);
  Future<OrganizationModel> createOrganization(OrganizationModel organization);
  Future<OrganizationModel> updateOrganization(
    String id,
    OrganizationModel organization,
  );
  Future<void> deleteOrganization(String id);
  Future<Map<String, dynamic>> switchOrganization(String id);
}

class OrganizationRemoteDataSourceImpl implements OrganizationRemoteDataSource {
  final ApiClient apiClient;

  OrganizationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<OrganizationModel>> getOrganizations() async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.getOrganizations}?page=1&limit=10',
      );
      final List<dynamic> data = response['data'] ?? [];
      return data.map((json) => OrganizationModel.fromJson(json)).toList();
    } catch (e) {
      try {
        
        final response = await apiClient.get(ApiEndpoints.getCurrentUser);
        final data = response['data'];
        if (data != null && data['organizations'] != null) {
          final List<dynamic> orgs = data['organizations'];
          return orgs.map((json) => OrganizationModel.fromJson(json)).toList();
        }
      } catch (_) {
        
      }
      rethrow;
    }
  }

  @override
  Future<OrganizationModel> getOrganizationDetails(String id) async {
    final response = await apiClient.get(
      '${ApiEndpoints.getOrganizationDetails}$id',
    );
    return OrganizationModel.fromJson(response['data'] ?? response);
  }

  @override
  Future<OrganizationModel> createOrganization(
    OrganizationModel organization,
  ) async {
    final response = await apiClient.post(
      ApiEndpoints.createOrganizationEndpoint,
      data: organization.toJson(),
    );
    return OrganizationModel.fromJson(response['data'] ?? response);
  }

  @override
  Future<OrganizationModel> updateOrganization(
    String id,
    OrganizationModel organization,
  ) async {
    final response = await apiClient.patch(
      '${ApiEndpoints.updateOrganization}$id',
      data: organization.toJson(),
    );
    return OrganizationModel.fromJson(response['data'] ?? response);
  }

  @override
  Future<void> deleteOrganization(String id) async {
    await apiClient.delete('${ApiEndpoints.deleteOrganization}$id');
  }

  @override
  Future<Map<String, dynamic>> switchOrganization(String id) async {
    final response = await apiClient.post(
      ApiEndpoints.switchOrganization,
      data: {'organization_id': id},
    );
    return response['data'] ?? response;
  }
}
