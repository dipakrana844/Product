import 'package:go_router/go_router.dart';

abstract class NavigationService {
  Future<void> pushNamed(String routeName, {Object? extra});

  Future<void> pushNamedAndRemoveUntil(String routeName, {Object? extra});

  void pop();

  void popWithResult<T>([T? result]);

  String? get currentRoute;

  bool get canPop;

  GoRouter get router;
}
