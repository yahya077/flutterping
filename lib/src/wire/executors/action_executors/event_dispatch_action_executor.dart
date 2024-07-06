part of '../action_executor.dart';
class EventDispatchActionExecutor extends ActionExecutor {
  EventDispatchActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final Event event = Event.fromJson(json.data);
    application
        .make<EventDispatcher>(WireDefinition.eventDispatcher)
        .dispatch(event);
  }
}