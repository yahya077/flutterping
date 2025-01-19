part of '../widget_builder.dart';

class ListTileBuilder extends WidgetBuilder {
  ListTileBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return StatelessWidget(
      builder: (context) {
        final title = Json.fromJson(json.data["title"]);
        final subTitle = json.data["subTitle"] != null
            ? Json.fromJson(json.data["subTitle"])
            : null;
        //TODO complete all the properties
        return material.ListTile(
            title: application
                .make<WidgetBuilder>(title.type)
                .build(title, context),
            subtitle: subTitle != null
                ? application
                    .make<WidgetBuilder>(subTitle.type)
                    .build(subTitle, context)
                : null,
            leading: json.data["leading"] != null
                ? application
                    .make<WidgetBuilder>(json.data["leading"]["type"])
                    .build(Json.fromJson(json.data["leading"]), context)
                : null,
            trailing: json.data["trailing"] != null
                ? application
                    .make<WidgetBuilder>(json.data["trailing"]["type"])
                    .build(Json.fromJson(json.data["trailing"]), context)
                : null,
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
            hoverColor: json.data["hoverColor"] == null
                ? null
                : Color.findColor(json.data["hoverColor"]).build(),
            onTap: json.data["onTap"] == null
                ? null
                : () {
                    application
                        .make<EventDispatcher>(WireDefinition.eventDispatcher)
                        .dispatch(Event.fromJson(json.data["onTap"]["data"]));
                  });
      },
    );
  }
}
