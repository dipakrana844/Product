import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/organization.dart';
import '../../domain/usecases/organization_usecases.dart';

// Events
abstract class OrganizationEvent extends Equatable {
  const OrganizationEvent();

  @override
  List<Object?> get props => [];
}

class GetOrganizationsRequested extends OrganizationEvent {}

class CreateOrganizationRequested extends OrganizationEvent {
  final Organization organization;
  const CreateOrganizationRequested(this.organization);

  @override
  List<Object?> get props => [organization];
}

class UpdateOrganizationRequested extends OrganizationEvent {
  final String id;
  final Organization organization;
  const UpdateOrganizationRequested(this.id, this.organization);

  @override
  List<Object?> get props => [id, organization];
}

class SwitchOrganizationRequested extends OrganizationEvent {
  final String id;
  const SwitchOrganizationRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteOrganizationRequested extends OrganizationEvent {
  final String id;
  const DeleteOrganizationRequested(this.id);

  @override
  List<Object?> get props => [id];
}

// States
abstract class OrganizationState extends Equatable {
  const OrganizationState();

  @override
  List<Object?> get props => [];
}

class OrganizationInitial extends OrganizationState {}

class OrganizationLoading extends OrganizationState {}

class OrganizationsLoaded extends OrganizationState {
  final List<Organization> organizations;
  const OrganizationsLoaded(this.organizations);

  @override
  List<Object?> get props => [organizations];
}

class OrganizationOperationSuccess extends OrganizationState {
  final String message;
  const OrganizationOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OrganizationError extends OrganizationState {
  final String message;
  const OrganizationError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrganizationOnboardingRequired extends OrganizationState {
  final String message;
  final String step;
  const OrganizationOnboardingRequired(this.message, this.step);

  @override
  List<Object?> get props => [message, step];
}

class OrganizationBloc extends Bloc<OrganizationEvent, OrganizationState> {
  final GetOrganizationsUseCase getOrganizations;
  final CreateOrganizationUseCase createOrganization;
  final UpdateOrganizationUseCase updateOrganization;
  final DeleteOrganizationUseCase deleteOrganization;
  final SwitchOrganizationUseCase switchOrganization;

  OrganizationBloc({
    required this.getOrganizations,
    required this.createOrganization,
    required this.updateOrganization,
    required this.deleteOrganization,
    required this.switchOrganization,
  }) : super(OrganizationInitial()) {
    on<GetOrganizationsRequested>(_onGetOrganizationsRequested);
    on<CreateOrganizationRequested>(_onCreateOrganizationRequested);
    on<UpdateOrganizationRequested>(_onUpdateOrganizationRequested);
    on<DeleteOrganizationRequested>(_onDeleteOrganizationRequested);
    on<SwitchOrganizationRequested>(_onSwitchOrganizationRequested);
  }

  Future<void> _onGetOrganizationsRequested(
    GetOrganizationsRequested event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(OrganizationLoading());
    final result = await getOrganizations(NoParams());
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (organizations) => emit(OrganizationsLoaded(organizations)),
    );
  }

  OrganizationState _mapFailureToState(Failure failure) {
    if (failure is OnboardingFailure ||
        failure.message.contains('CREATE_ORGANIZATION') ||
        failure.message.contains('Onboarding is not completed')) {
      return OrganizationOnboardingRequired(
        failure.message,
        'CREATE_ORGANIZATION',
      );
    }
    return OrganizationError(failure.message);
  }

  Future<void> _onCreateOrganizationRequested(
    CreateOrganizationRequested event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(OrganizationLoading());
    final result = await createOrganization(event.organization);
    result.fold((failure) => emit(_mapFailureToState(failure)), (organization) {
      emit(
        const OrganizationOperationSuccess(
          'Organization Created Successfully!',
        ),
      );
      add(GetOrganizationsRequested());
    });
  }

  Future<void> _onUpdateOrganizationRequested(
    UpdateOrganizationRequested event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(OrganizationLoading());
    final result = await updateOrganization(
      UpdateOrganizationParams(event.id, event.organization),
    );
    result.fold((failure) => emit(_mapFailureToState(failure)), (organization) {
      emit(
        const OrganizationOperationSuccess(
          'Organization Updated Successfully!',
        ),
      );
      add(GetOrganizationsRequested());
    });
  }

  Future<void> _onDeleteOrganizationRequested(
    DeleteOrganizationRequested event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(OrganizationLoading());
    final result = await deleteOrganization(event.id);
    result.fold((failure) => emit(_mapFailureToState(failure)), (_) {
      emit(
        const OrganizationOperationSuccess(
          'Organization Deleted Successfully!',
        ),
      );
      add(GetOrganizationsRequested());
    });
  }

  Future<void> _onSwitchOrganizationRequested(
    SwitchOrganizationRequested event,
    Emitter<OrganizationState> emit,
  ) async {
    emit(OrganizationLoading());
    final result = await switchOrganization(event.id);
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) => emit(
        const OrganizationOperationSuccess(
          'Switched Organization Successfully!',
        ),
      ),
    );
  }
}
