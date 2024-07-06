part of '../widget_builder.dart';

class IntrinsicHeightBuilder extends WidgetBuilder {
  IntrinsicHeightBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    return material.IntrinsicHeight(
      child: json.data['child'] == null
          ? null
          : application
              .make<WidgetBuilder>(json.data['child']['type'])
              .build(Json.fromJson(json.data['child'])),
    );
  }
}
