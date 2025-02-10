part of '../widget_builder.dart';

class CheckboxFormFieldBuilder extends WidgetBuilder {
  CheckboxFormFieldBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return PingCheckboxField(
      name: json.data["name"],
      title: json.data["title"] == null
          ? null
          : application
              .make<Builder>(json.data["title"]["type"])
              .build(Json.fromJson(json.data["title"]), context),
      subTitle: json.data["subTitle"] == null
          ? null
          : application
              .make<Builder>(json.data["subTitle"]["type"])
              .build(Json.fromJson(json.data["subTitle"]), context),
      initialValue: json.data["initialValue"] != null
        ? application
            .make<ValueBuilder>(json.data["initialValue"]["type"])
        .build(Json.fromJson(json.data["initialValue"]), context)
        : false,
      decoration: json.data["decoration"] == null
        ? null
            : application
            .make<Builder>(json.data["decoration"]["type"])
        .build(Json.fromJson(json.data["decoration"]), context),
      onChanged: json.data["onChanged"] != null
          ? (value) {
              application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(Event.fromJson(json.data["onChanged"]["data"]));
            }
          : null,
      validator: json.data["validator"] == null
          ? null
          : application
              .make<Builder>(json.data["validator"]["type"])
              .build(Json.fromJson(json.data["validator"]), context),
      tristate: json.data["tristate"] ?? false,
      mouseCursor: json.data["mouseCursor"],
      //TODO mouse cursor builder
      activeColor: json.data["activeColor"] == null
          ? null
          : Color.findColor(json.data["activeColor"]).build(),
      //fillColor: , TODO: implement
      checkColor: json.data["checkColor"] == null
          ? null
          : Color.findColor(json.data["checkColor"]).build(),
      focusColor: json.data["focusColor"] == null
          ? null
          : Color.findColor(json.data["focusColor"]).build(),
      hoverColor: json.data["hoverColor"] == null
          ? null
          : Color.findColor(json.data["hoverColor"]).build(),
      //overlayColor: , TODO: implement
      splashRadius: json.data["splashRadius"] == null
          ? 0.0
          : json.data["splashRadius"].toDouble(),
      //materialTapTargetSize: , TODO: implement
      //visualDensity: ,TODO: implement
      //focusNode: ,TODO: implement
      autofocus: json.data["autofocus"] ?? false,
      contentPadding: json.data["contentPadding"] == null
          ? null
          : EdgeInsets.findJson(json.data["contentPadding"]).build(),
      shape: json.data["shape"] == null
          ? null
          : OutlinedBorderFactory.findJson(json.data["shape"]).build(),
      checkboxShape: json.data["checkboxShape"] == null
          ? null
          : OutlinedBorderFactory.findJson(json.data["checkboxShape"]).build(),
      side: json.data["side"] == null
          ? null
          : BorderSide.findJson(json.data["side"]).build(),
      isError: json.data["isError"] ?? false,
      semanticLabel: json.data["semanticLabel"],
    );
  }
}
//TODO: implement PingFieldBuilder
