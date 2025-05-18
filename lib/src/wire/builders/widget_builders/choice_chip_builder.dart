part of '../widget_builder.dart';

class ChoiceChipBuilder extends WidgetBuilder {
  ChoiceChipBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.ChoiceChip(
      selected: json.data["selected"] ?? false,
      onSelected: json.data["onSelected"] == null
          ? null
          : (bool selected) {
              if (json.data["onSelected"] is Function) {
                final onSelected = json.data["onSelected"] as Function;
                onSelected(selected);
              } else if (json.data["onSelected"] is Map) {
                application
                    .make<EventDispatcher>(WireDefinition.eventDispatcher)
                    .dispatch(Event.fromJson(json.data["onSelected"]["data"]));
              }
            },
      label: application
          .make<WidgetBuilder>(json.data["label"]["type"])
          .build(Json.fromJson(json.data["label"]), context),
      avatar: json.data["avatar"] != null
          ? application
              .make<WidgetBuilder>(json.data["avatar"]["type"])
              .build(Json.fromJson(json.data["avatar"]), context)
          : null,
      selectedColor: json.data["selectedColor"] != null
          ? Color.fromJson(json.data["selectedColor"]).build()
          : null,
      backgroundColor: json.data["backgroundColor"] != null
          ? Color.fromJson(json.data["backgroundColor"]).build()
          : null,
      disabledColor: json.data["disabledColor"] != null
          ? Color.fromJson(json.data["disabledColor"]).build()
          : null,
      labelPadding: json.data["labelPadding"] != null
          ? EdgeInsets.findJson(json.data["labelPadding"]).build()
          : null,
      pressElevation: DoubleFactory.fromDynamic(json.data["pressElevation"]),
      elevation: DoubleFactory.fromDynamic(json.data["elevation"]),
      shadowColor: json.data["shadowColor"] != null
          ? Color.fromJson(json.data["shadowColor"]).build()
          : null,
      shape: json.data["shape"] != null
          ? OutlinedBorderFactory.findJson(json.data["shape"]).build()
          : null,
      padding: json.data["padding"] != null
          ? EdgeInsets.findJson(json.data["padding"]).build()
          : null,
      clipBehavior: json.data["clipBehavior"] != null
          ? Clip.fromJson(json.data["clipBehavior"]).build()
          : material.Clip.none,
    );
  }
}
