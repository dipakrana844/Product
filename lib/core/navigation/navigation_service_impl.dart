import 'package:go_router/go_router.dart';
import 'navigation_service.dart';

class NavigationServiceImpl implements NavigationService {
  final GoRouter _router;

  NavigationServiceImpl(this._router);

  @override
  GoRouter get router => _router;

  @override
  Future<void> pushNamed(String routeName, {Object? extra}) {
    return _router.pushNamed(routeName, extra: extra);
  }

  @override
  Future<void> pushNamedAndRemoveUntil(String routeName, {Object? extra}) async {
    
    _router.goNamed(routeName, extra: extra);
  }

  @override
  void pop() {
    _router.pop();
  }

  @override
  void popWithResult<T>([T? result]) {
    _router.pop(result);
  }

  @override
  String? get currentRoute {
    return _router.routeInformationProvider.value.uri.toString();
  }

  @override
  bool get canPop {
    
    return true;
  }
}