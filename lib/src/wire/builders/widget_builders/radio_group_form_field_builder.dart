part of '../widget_builder.dart';

class RadioGroupFormFieldBuilder extends WidgetBuilder {
  RadioGroupFormFieldBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return PingRadioGroupField(
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
      initialValue: json.data["initialValue"] ?? false,
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
      options: (json.data["options"] as List).map((option) {
        final optionJson = Json.fromJson(option);
        return material.RadioListTile(
          //we are using RadioListTile as a dto
          value: application
              .make<ValueBuilder>(optionJson.data["value"]["type"])
              .build(Json.fromJson(optionJson.data["value"]), context),
          groupValue: null,
          onChanged: (value) {},
          mouseCursor: optionJson.data["mouseCursor"],
          toggleable: optionJson.data["toggleable"] ?? false,
          //TODO mouse cursor builder
          activeColor: optionJson.data["activeColor"] == null
              ? null
              : Color.findColor(optionJson.data["activeColor"]).build(),
          //fillColor: , TODO: implement
          hoverColor: optionJson.data["hoverColor"] == null
              ? null
              : Color.findColor(optionJson.data["hoverColor"]).build(),
          //overlayColor: , TODO: implement
          splashRadius: optionJson.data["splashRadius"] == null
              ? 0.0
              : optionJson.data["splashRadius"].toDouble(),
          //materialTapTargetSize: , TODO: implement
          title: optionJson.data["title"] == null
              ? null
              : application
                  .make<Builder>(optionJson.data["title"]["type"])
                  .build(Json.fromJson(optionJson.data["title"]), context),
          subtitle: optionJson.data["subTitle"] == null
              ? null
              : application
                  .make<Builder>(optionJson.data["subTitle"]["type"])
                  .build(Json.fromJson(optionJson.data["subTitle"]), context),
          //visualDensity: ,TODO: implement
          //focusNode: ,TODO: implement
          autofocus: optionJson.data["autofocus"] ?? false,
          contentPadding: optionJson.data["contentPadding"] == null
              ? null
              : EdgeInsets.findJson(optionJson.data["contentPadding"]).build(),
          shape: optionJson.data["shape"] == null
              ? null
              : OutlinedBorderFactory.findJson(optionJson.data["shape"]).build(),
        );
      }).toList(),
    );
  }
}
//TODO: implement PingFieldBuilder
