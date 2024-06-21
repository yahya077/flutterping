import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:go_router/go_router.dart';

class GoRouterRoutingService extends RoutingService {
  GoRouterRoutingService(Application application) : super(application);

  @override
  void navigateTo(String path,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) {
    getMainNavigatorKey().currentState!.context.push(path, extra: data);
  }

  @override
  void navigateBack() {
    getMainNavigatorKey().currentState!.context.pop();
  }

  @override
  void navigateToRoot() {
    getMainNavigatorKey().currentState!.popUntil((route) => route.isFirst);
  }

  @override
  void navigateToNamed(String path,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) {
    getMainNavigatorKey().currentState!.context.pushNamed(path, queryParameters: queryParameters ?? {}, extra: data);
  }

  @override
  void navigateToNamedAndRemoveUntil(String path,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) {
    getMainNavigatorKey().currentState!.context.goNamed(path, queryParameters: queryParameters ?? {}, extra: data);
  }

  @override
  void navigateAndRemoveUntil(String path,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) {
    getMainNavigatorKey().currentState!.context.go(path, extra: data);
  }

  @override
  void changeStack(String stackKey, int index, {bool initialLocation = false}) {
    getStackKey(stackKey).goBranch(index, initialLocation: initialLocation);
  }

  @override
  void changeStackAndNavigate(String stackKey, int index, String path,
      {Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? data,
        bool initialLocation = false}) {
    getStackKey(stackKey).goBranch(index, initialLocation: initialLocation);
    getMainNavigatorKey().currentState!.context.push(path, extra: data);
  }
}
