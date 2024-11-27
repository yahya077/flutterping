part of '../widget_builder.dart';

class TextFormFieldBuilder extends WidgetBuilder {
  TextFormFieldBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return PingTextField(
      name: json.data["name"],
      initialValue: json.data["initialValue"],
      onChanged: json.data["onChanged"] != null
          ? (value) {
              application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(Event.fromJson(json.data["onChanged"]["data"]));
            }
          : null,
      onSaved: json.data["onSaved"] != null
          ? (value) {
              application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(Event.fromJson(json.data["onSaved"]["data"]));
            }
          : null,
      controller: json.data["controller"] == null
          ? null
          : application
              .make<TextEditingControllerBuilder>(
                  json.data["controller"]["type"])
              .build(Json.fromJson(json.data["controller"]), context),
      decoration: json.data["decoration"] == null
          ? null
          : application
              .make<Builder>(json.data["decoration"]["type"])
              .build(Json.fromJson(json.data["decoration"]), context),
      maxLength: json.data["maxLength"],
      maxLines: json.data["maxLines"],
      obscureText: json.data["obscureText"] ?? false,
      minLines: json.data["minLines"],
      onEditingComplete: json.data["onEditingComplete"] != null
          ? () {
              application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(
                      Event.fromJson(json.data["onEditingComplete"]["data"]));
            }
          : null,
    );
  }
}
//TODO: implement PingFieldBuilder