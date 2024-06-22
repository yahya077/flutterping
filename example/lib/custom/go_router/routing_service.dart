import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:go_router/go_router.dart';

class GoRouterRoutingService extends RoutingService {
  GoRouterRoutingService(Application application) : super(application);

  @override
  void navigateTo(String navigatorKey, String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? pathParameters,
      Map<String, dynamic>? data}) {
    getNavigatorKey(navigatorKey).currentState!.context.push(path, extra: data);
  }

  @override
  void navigateBack(String navigatorKey) {
    getNavigatorKey(navigatorKey).currentState!.context.pop();
  }

  @override
  void navigateToRoot(String navigatorKey) {
    getNavigatorKey(navigatorKey)
        .currentState!
        .popUntil((route) => route.isFirst);
  }

  @override
  void navigateToNamed(String navigatorKey, String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? pathParameters,
      Map<String, dynamic>? data}) {
    getNavigatorKey(navigatorKey).currentState!.context.pushNamed(path,
        queryParameters: queryParameters ?? {},
        pathParameters: pathParameters ?? {},
        extra: data);
  }

  @override
  void navigateToNamedAndRemoveUntil(String navigatorKey, String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? pathParameters,
      Map<String, dynamic>? data}) {
    getNavigatorKey(navigatorKey).currentState!.context.goNamed(path,
        queryParameters: queryParameters ?? {},
        pathParameters: pathParameters ?? {},
        extra: data);
  }

  @override
  void navigateAndRemoveUntil(String navigatorKey, String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? pathParameters,
      Map<String, dynamic>? data}) {
    getNavigatorKey(navigatorKey).currentState!.context.go(path, extra: data);
  }

  @override
  void changeStack(String stackKey, int index, {bool initialLocation = false}) {
    getStackKey(stackKey).goBranch(index, initialLocation: initialLocation);
  }

  @override
  void changeStackAndNavigate(
      String navigatorKey, String stackKey, int index, String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? pathParameters,
      Map<String, dynamic>? data,
      bool initialLocation = false}) {
    getStackKey(stackKey).goBranch(index, initialLocation: initialLocation);
    getNavigatorKey(navigatorKey).currentState!.context.push(path, extra: data);
  }
}
