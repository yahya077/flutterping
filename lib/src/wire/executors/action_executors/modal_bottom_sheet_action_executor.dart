part of '../action_executor.dart';

class ModalBottomSheetActionExecutor extends ActionExecutor {
  ModalBottomSheetActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    material.showModalBottomSheet(
      enableDrag: json.data["enableDrag"] ?? true,
      showDragHandle: json.data["showDragHandle"] ?? false,
      isScrollControlled: json.data["isScrollControlled"] ?? false,
      useSafeArea: json.data["useSafeArea"] ?? false,
      isDismissible: json.data["isDismissible"] ?? true,
      context: context,
      shape: const material.RoundedRectangleBorder(
        borderRadius: material.BorderRadius.vertical(
          top: material.Radius.circular(25.0),
        ),
      ),
      builder: (material.BuildContext context) {
        return material.GestureDetector(
          onTap: () {
            if (json.data["isDismissible"] ?? false) {
              material.FocusScope.of(context)
                  .requestFocus(material.FocusNode());
            }
          },
          child: application
              .make<WidgetBuilder>(json.data["content"]["type"])
              .build(Json.fromJson(json.data["content"]), context),
        );
      },
    );
  }
}
