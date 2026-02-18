import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/custom_elevated_button.dart';
import '../bloc/organization_bloc.dart';
import '../../domain/entities/organization.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<OrganizationBloc>().add(GetOrganizationsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              context.go(AppRoutes.login);
            } else if (state is OrgCreationRequired) {
              context.go(AppRoutes.createOrganization);
            }
          },
        ),
        BlocListener<OrganizationBloc, OrganizationState>(
          listener: (context, state) {
            if (state is OrganizationOperationSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));

              // If switched, refresh both auth and organizations to get updated context
              if (state.message.contains('Switched')) {
                context.read<AuthBloc>().add(CheckAuthStatus());
                context.read<OrganizationBloc>().add(
                  GetOrganizationsRequested(),
                );
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 16,
          title: const OrganizationSwitcher(),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Color(0xFF1E293B)),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AuthError) {
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
                      onPressed: () =>
                          context.read<AuthBloc>().add(CheckAuthStatus()),
                    ),
                  ],
                ),
              );
            }

            String firstName = OrganizationStrings.noOrganization;
            String email = '';
            String phone = '';

            if (state is AuthAuthenticated) {
              firstName = state.user.firstName;
              email = state.user.email;
              phone = state.user.phone.value;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: const Color(
                            0xFF3F69B8,
                          ).withOpacity(0.1),
                          child: Text(
                            firstName.isNotEmpty
                                ? firstName[0].toUpperCase()
                                : OrganizationStrings.noOrganization[0]
                                      .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3F69B8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${OrganizationStrings.helloUser}$firstName',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: GoogleFonts.inter(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              if (phone.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  phone,
                                  style: GoogleFonts.inter(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    OrganizationStrings.quickActions,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Actions Grid/List
                  _ActionTile(
                    title: OrganizationStrings.manageOrganizations,
                    subtitle: OrganizationStrings.manageOrganizationsSubtitle,
                    icon: Icons.business_center_rounded,
                    color: const Color(0xFF3F69B8),
                    onTap: () => context.push(AppRoutes.organizationList),
                  ),

                  _ActionTile(
                    title: OrganizationStrings.changePassword,
                    subtitle: OrganizationStrings.changePasswordSubtitle,
                    icon: Icons.lock_outline_rounded,
                    color: const Color(0xFF64748B),
                    onTap: () {
                      context.push(AppRoutes.newPassword);
                    },
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                      icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                      label: Text(
                        OrganizationStrings.logout,
                        style: GoogleFonts.inter(
                          color: const Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrganizationSwitcher extends StatelessWidget {
  const OrganizationSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationBloc, OrganizationState>(
      builder: (context, state) {
        String activeOrgName = 'Select Organization';
        List<Organization> organizations = [];
        String? activeOrgId;

        // Try to get active org from auth state first as a baseline
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated) {
          activeOrgId = authState.user.activeOrganizationId;
        }

        if (state is OrganizationsLoaded) {
          organizations = state.organizations;

          // Find organization by activeOrgId or fallback to first
          final activeOrg =
              organizations.where((o) => o.id == activeOrgId).firstOrNull ??
              (organizations.isNotEmpty ? organizations.first : null);

          activeOrgName = activeOrg?.name ?? 'Select Organization';
        } else if (state is OrganizationLoading) {
          activeOrgName = AppStrings.loading;
        } else if (state is OrganizationError) {
          // Instead of "Error", we show "Select Organization" for a cleaner look
          activeOrgName = 'Select Organization';
        }

        return Theme(
          data: Theme.of(context).copyWith(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 50),
            constraints: const BoxConstraints(minWidth: 240, maxWidth: 280),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            elevation: 8,
            onSelected: (action) {
              if (action == 'create_new') {
                context.push(AppRoutes.createOrganization);
              } else if (action == 'manage') {
                context.push(AppRoutes.organizationList);
              } else {
                // It's an organization ID
                context.read<OrganizationBloc>().add(
                  SwitchOrganizationRequested(action),
                );
              }
            },
            itemBuilder: (context) {
              return [
                ...organizations.map(
                  (org) => PopupMenuItem<String>(
                    value: org.id,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.business_rounded,
                          color: Color(0xFF3F69B8),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            org.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (org.name == activeOrgName)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF3F69B8),
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'manage',
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        OrganizationStrings.manageOrganizations,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'create_new',
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        OrganizationStrings.createOrganization,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF3F69B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://api.dicebear.com/7.x/avataaars/png?seed=Rick', // Placeholder similar to the image
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.business_rounded,
                              color: Color(0xFF3F69B8),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    activeOrgName,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3B5A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF2D3B5A),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
