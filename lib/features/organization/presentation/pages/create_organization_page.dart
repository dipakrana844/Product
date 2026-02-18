import 'package:auth_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/form_text_field.dart';
import '../../../../core/widgets/phone_input_field.dart';
import '../../../../core/domain/value_objects/phone_number.dart';
import '../bloc/organization_bloc.dart';
import '../../domain/entities/organization.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/domain/entities/user.dart' as auth_user;

class CreateOrganizationPage extends StatefulWidget {
  final Organization? organization; // If provided, we are updating

  const CreateOrganizationPage({super.key, this.organization});

  @override
  State<CreateOrganizationPage> createState() => _CreateOrganizationPageState();
}

class _CreateOrganizationPageState extends State<CreateOrganizationPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _orgNameController;
  String _selectedTeamSize = '25 to 30';
  bool _isInitialOnboarding = false;

  final List<String> _teamSizes = [
    '1 to 10',
    '11 to 25',
    '25 to 30',
    '31 to 50',
    '50+',
  ];

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is OrgCreationRequired) {
      _isInitialOnboarding = true;
    }
    auth_user.User? currentUser;
    if (authState is AuthAuthenticated) {
      currentUser = authState.user;
    }

    if (widget.organization != null) {
      // Update mode

      _emailController = TextEditingController(
        text: widget.organization!.email ?? '',
      );
      _phoneController = TextEditingController(
        text: widget.organization!.phone?.value ?? '',
      );
      _orgNameController = TextEditingController(
        text: widget.organization!.name,
      );
      _selectedTeamSize = _mapIntToTeamSize(widget.organization!.team_size);
    } else {
      // Create mode

      _emailController = TextEditingController(text: currentUser?.email ?? '');
      _phoneController = TextEditingController(
        text: currentUser?.phone.value ?? '',
      );
      _orgNameController = TextEditingController(text: '');
      _selectedTeamSize = _teamSizes[0]; // Or pick a default
    }
  }

  String _mapIntToTeamSize(int size) {
    if (size <= 10) return '1 to 10';
    if (size <= 25) return '11 to 25';
    if (size <= 30) return '25 to 30';
    if (size <= 50) return '31 to 50';
    return '50+';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _orgNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A233A), // Dark Navy
              Color(0xFF2D3B5A),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content centered
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.organization == null
                                ? OrganizationStrings.createOrganizationTitle
                                : OrganizationStrings.updateOrganizationTitle,
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 32),

                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, authState) {
                              if (_isInitialOnboarding ||
                                  authState is OrgCreationRequired) {
                                return const SizedBox.shrink();
                              }
                              return Column(
                                children: [
                                  FormTextField(
                                    controller: _emailController,
                                    hint: AppStrings.emailHint,
                                    keyboardType: TextInputType.emailAddress,
                                    borderOnly: true,
                                  ),
                                  const SizedBox(height: 16),
                                  PhoneInputField(
                                    controller: _phoneController,
                                    hint: AppStrings.phoneNumberHint,
                                    borderOnly: true,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) return null;
                                      final result =
                                          PhoneNumberValidator.validate(v);
                                      return result.isValid
                                          ? null
                                          : result.errorMessage;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),

                          FormTextField(
                            controller: _orgNameController,
                            hint: OrganizationStrings.organizationNameHint,
                            borderOnly: true,
                          ),
                          const SizedBox(height: 16),

                          _buildTeamSizeDropdown(),
                          const SizedBox(height: 32),

                          MultiBlocListener(
                            listeners: [
                              BlocListener<OrganizationBloc, OrganizationState>(
                                listener: (context, state) {
                                  if (state is OrganizationOperationSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                    if (context.canPop()) {
                                      context.pop();
                                    }
                                  } else if (state is OrganizationError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else if (state
                                      is OrganizationOnboardingRequired) {
                                    _onSave(useAuthBloc: true);
                                  }
                                },
                              ),
                              BlocListener<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is AuthAuthenticated) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          OrganizationStrings
                                              .organizationNameRequiredMessage,
                                        ),
                                      ),
                                    );
                                    context.go(AppRoutes.home);
                                  } else if (state is AuthError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                            child:
                                BlocBuilder<
                                  OrganizationBloc,
                                  OrganizationState
                                >(
                                  builder: (context, orgState) {
                                    return BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, authState) {
                                        final isLoading =
                                            orgState is OrganizationLoading ||
                                            authState is AuthLoading;

                                        return CustomElevatedButton(
                                          text: widget.organization == null
                                              ? OrganizationStrings
                                                    .saveAndContinue
                                              : OrganizationStrings
                                                    .updateOrganizationTitle,
                                          onPressed: isLoading
                                              ? null
                                              : () => _onSave(),
                                          isLoading: isLoading,
                                        );
                                      },
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (context.canPop())
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSizeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC4C4C4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTeamSize,
          isExpanded: true,
          items: _teamSizes.map((size) {
            return DropdownMenuItem(
              value: size,
              child: Text(size, style: const TextStyle(fontSize: 16)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedTeamSize = value);
            }
          },
        ),
      ),
    );
  }

  void _onSave({bool useAuthBloc = false}) {
    // Basic validation
    if (_orgNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(OrganizationStrings.organizationNameRequired),
        ),
      );
      return;
    }

    final teamSizeInt = _parseTeamSize(_selectedTeamSize);

    if (widget.organization == null) {
      // Logic for new organization
      final authState = context.read<AuthBloc>().state;

      // If useAuthBloc is forced or if auth state indicates onboarding is needed
      if (useAuthBloc || authState is OrgCreationRequired) {
        final Map<String, dynamic> orgData = {
          'organization': {
            'name': _orgNameController.text.trim(),
            'team_size': teamSizeInt,
          },
        };
        context.read<AuthBloc>().add(OrganizationCreateRequested(orgData));
      } else {
        final phone = _phoneController.text.trim().isNotEmpty
            ? PhoneNumber.tryCreate(_phoneController.text.trim())
            : null;

        final org = Organization(
          id: '',
          name: _orgNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: phone,
          team_size: teamSizeInt,

          address: "123 Main St",
          city: "Surat",
          state: "Gujarat",
          zipCode: "395001",
          country: "India",
          website: "https://www.example.com",
          logo: "https://www.example.com/logo.png",
          description: "This is a test organization",
        );
        context.read<OrganizationBloc>().add(CreateOrganizationRequested(org));
      }
    } else {
      // Update existing
      // Use copyWith to ensure we don't lose data for fields not in this form
      final phone = _phoneController.text.trim().isNotEmpty
          ? PhoneNumber.tryCreate(_phoneController.text.trim())
          : null;

      final org = widget.organization!.copyWith(
        name: _orgNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: phone,
        team_size: teamSizeInt,
        address: "123 Main St",
        city: "Surat",
        state: "Gujarat",
        zipCode: "395001",
        country: "India",
        website: "https://www.example.com",
        logo: "https://www.example.com/logo.png",
        description: "This is a test organization",
      );
      context.read<OrganizationBloc>().add(
        UpdateOrganizationRequested(org.id, org),
      );
    }
  }

  int _parseTeamSize(String size) {
    if (size == '1 to 10') return 10;
    if (size == '11 to 25') return 25;
    if (size == '25 to 30') return 30;
    if (size == '31 to 50') return 50;
    if (size == '50+') return 100; // Return a value indicating 50+
    return 10; // Default
  }
}
