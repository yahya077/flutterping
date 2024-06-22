part of '../action_executor.dart';

class NavigationActionExecutor extends ActionExecutor {
  NavigationActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Element element) async {
    //TODO implement strategies for NavigationPath
    final path = NavigationPath.fromJson(element.data["path"]["data"]);
    if (path.stackKey != null &&
        path.index != null &&
        path.path != "" &&
        path.path != null) {
      application
          .make<RoutingService>(WireDefinition.routingService)
          .changeStackAndNavigate(
              path.navigatorKey!, path.stackKey!, path.index!, path.path!,
              queryParameters: path.queryParameters,
              pathParameters: path.pathParameters);
    } else if (path.stackKey != null && path.index != null) {
      application
          .make<RoutingService>(WireDefinition.routingService)
          .changeStack(path.stackKey!, path.index!);
    } else {
      application
          .make<RoutingService>(WireDefinition.routingService)
          .navigateToNamed(path.navigatorKey!, path.path!,
              queryParameters: path.queryParameters,
              pathParameters: path.pathParameters);
    }
  }
}
