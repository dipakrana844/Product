import 'package:auth_app/core/theme/app_theme.dart';
import 'package:auth_app/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/widgets/network_aware_widget.dart';
import 'core/network/network_cubit.dart';
import 'core/constants/app_strings.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/organization/presentation/bloc/organization_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = di.sl<AuthBloc>()..add(CheckAuthStatus());
    final navigationService = di.sl<NavigationService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<OrganizationBloc>(
          create: (context) => di.sl<OrganizationBloc>(),
        ),
      ],
      child: BlocProvider.value(
        value: di.sl<NetworkCubit>(),
        child: MaterialApp.router(
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: navigationService.router,
          builder: (context, child) {
            return NetworkAwareWidget(child: child!);
          },
        ),
      ),
    );
  }
}
