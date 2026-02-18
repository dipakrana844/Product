import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../bloc/organization_bloc.dart';
import '../../domain/entities/organization.dart';

class OrganizationListPage extends StatefulWidget {
  const OrganizationListPage({super.key});

  @override
  State<OrganizationListPage> createState() => _OrganizationListPageState();
}

class _OrganizationListPageState extends State<OrganizationListPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrganizationBloc>().add(GetOrganizationsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          OrganizationStrings.myOrganizations,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              context.push(AppRoutes.createOrganization);
            },
          ),
        ],
      ),
      body: BlocListener<OrganizationBloc, OrganizationState>(
        listener: (context, state) {
          if (state is OrganizationOnboardingRequired) {
            context.go(AppRoutes.createOrganization);
          }
        },
        child: BlocBuilder<OrganizationBloc, OrganizationState>(
          builder: (context, state) {
            if (state is OrganizationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrganizationOnboardingRequired) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrganizationOperationSuccess) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrganizationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      text: AppStrings.retry,
                      onPressed: () => context.read<OrganizationBloc>().add(
                        GetOrganizationsRequested(),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is OrganizationsLoaded) {
              final organizations = state.organizations;

              if (organizations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business_rounded,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        OrganizationStrings.noOrganizationsFound,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomElevatedButton(
                        text: OrganizationStrings.createFirstOrganization,
                        onPressed: () {
                          context.push(AppRoutes.createOrganization);
                        },
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OrganizationBloc>().add(
                    GetOrganizationsRequested(),
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: organizations.length,
                  itemBuilder: (context, index) {
                    final org = organizations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: const Color(
                            0xFF3F69B8,
                          ).withOpacity(0.1),
                          child: Text(
                            org.name.isNotEmpty
                                ? org.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Color(0xFF3F69B8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          org.name,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${org.team_size}${OrganizationStrings.teamSizeEmployees}',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          // Open edit details on tap instead of switch
                          context.push(AppRoutes.createOrganization, extra: org);
                        },
                        onLongPress: () {
                          // Options to edit or delete
                          _showOptions(context, org);
                        },
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, Organization org) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text(OrganizationStrings.editDetails),
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutes.createOrganization, extra: org);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
            ),
            title: const Text(
              OrganizationStrings.deleteOrganization,
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _confirmDelete(context, org);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Organization org) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(OrganizationStrings.deleteOrganizationConfirm),
        content: Text(
          'Are you sure you want to delete ${org.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OrganizationBloc>().add(
                DeleteOrganizationRequested(org.id),
              );
            },
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
