part of '../action_executor.dart';
class EventDispatchActionExecutor extends ActionExecutor {
  EventDispatchActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final Event event = Event.fromJson(json.data);
    application
        .make<EventDispatcher>(WireDefinition.eventDispatcher)
        .dispatch(event);

    if (json.data["thenAction"] != null) {
      await application.make<ActionExecutor>(json.data["thenAction"]["type"]).execute(context, Json.fromJson(json.data["thenAction"]));
    }
  }
}