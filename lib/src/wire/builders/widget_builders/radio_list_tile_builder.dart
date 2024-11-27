part of '../widget_builder.dart';

class RadioListTileBuilder extends WidgetBuilder {
  RadioListTileBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return StatelessWidget(
      builder: (context) {
        final title = Json.fromJson(json.data["title"]);
        final subTitle = json.data["subTitle"] != null
            ? Json.fromJson(json.data["subTitle"])
            : null;
        final secondary = json.data["secondary"] != null
            ? Json.fromJson(json.data["secondary"])
            : null;
        return material.RadioListTile(
          title:
              application.make<WidgetBuilder>(title.type).build(title, context),
          subtitle: subTitle != null
              ? application
                  .make<WidgetBuilder>(subTitle.type)
                  .build(subTitle, context)
              : null,
          secondary: secondary != null
              ? application
                  .make<WidgetBuilder>(secondary.type)
                  .build(secondary, context)
              : null,
          groupValue: application
              .make<ValueBuilder>(json.data["groupValue"]["type"])
              .build(Json.fromJson(json.data["groupValue"]), context),
          value: json.data["value"],
          onChanged: (value) {
            json.data["onChanged"] == null
                ? null
                : application
                    .make<EventDispatcher>(WireDefinition.eventDispatcher)
                    .scopedEventDispatch(
                        Event.fromJson(json.data["onChanged"]["data"]), {
                    "value": value,
                  });
          },
          isThreeLine: json.data["isThreeLine"] ?? false,
          dense: json.data["dense"] ?? false,
          selected: json.data["selected"] ?? false,
          contentPadding: json.data["contentPadding"] == null
              ? null
              : EdgeInsets.findJson(json.data["contentPadding"]).build(),
          tileColor: json.data["tileColor"] == null
              ? null
              : Color.findColor(json.data["tileColor"]).build(),
          selectedTileColor: json.data["selectedTileColor"] == null
              ? null
              : Color.findColor(json.data["selectedTileColor"]).build(),
          activeColor: json.data["activeColor"] == null
              ? null
              : Color.findColor(json.data["activeColor"]).build(),
          hoverColor: json.data["hoverColor"] == null
              ? null
              : Color.findColor(json.data["hoverColor"]).build(),
          splashRadius: json.data["splashRadius"] == null
              ? null
              : json.data["splashRadius"].toDouble(),
        );
      },
    );
  }
}
