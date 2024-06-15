part of '../action_executor.dart';

class ActionExecutor extends ElementExecutor {
  ActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Element element) async {
    await application
        .make<ActionExecutor>(element.type)
        .execute(context, element);
  }
}