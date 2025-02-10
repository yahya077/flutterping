part of '../widget_builder.dart';

class TextFormFieldBuilder extends WidgetBuilder {
  TextFormFieldBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    //TODO add keyboard type
    return PingTextField(
      name: json.data["name"],
      initialValue: json.data["initialValue"] != null
          ? application
              .make<ValueBuilder>(json.data["initialValue"]["type"])
              .build(Json.fromJson(json.data["initialValue"]), context)
          : null,
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
      validator: json.data["validator"] == null
          ? null
          : application
              .make<Builder>(json.data["validator"]["type"])
              .build(Json.fromJson(json.data["validator"]), context),
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
      keyboardType: json.data["keyboardType"] == null
          ? material.TextInputType.text
          : TextInputType.fromJson(json.data["keyboardType"]).build(),
      textInputAction: json.data["textInputAction"] == null
          ? null
          : TextInputAction.fromJson(json.data["textInputAction"]).build(),
    );
  }
}
//TODO: implement PingFieldBuilder
