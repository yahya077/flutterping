part of '../action_executor.dart';
class EventDispatchActionExecutor extends ActionExecutor {
  EventDispatchActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Element element) async {
    final Event event = Event.fromJson(element.data["event"]["data"]);
    application
        .make<EventDispatcher>(WireDefinition.eventDispatcher)
        .dispatch(event);
  }
}