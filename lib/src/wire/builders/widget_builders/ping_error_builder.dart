part of '../widget_builder.dart';

/// JSON builder for PingErrorView widget
/// Allows customization of error displays through JSON configuration
class PingErrorBuilder extends WidgetBuilder {
  PingErrorBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    // Extract the error data from the JSON
    final dynamic error = json.data["error"] ?? "Unknown error";
    
    // Extract stack trace if provided
    StackTrace? stackTrace;
    if (json.data["stackTrace"] != null) {
      stackTrace = StackTrace.fromString(json.data["stackTrace"]);
    }
    
    // Request information
    Map<String, dynamic>? requestInfo;
    if (json.data["requestInfo"] is Map) {
      requestInfo = Map<String, dynamic>.from(json.data["requestInfo"]);
    }
    
    // Context data
    Map<String, dynamic>? contextData;
    if (json.data["context"] is Map) {
      contextData = Map<String, dynamic>.from(json.data["context"]);
    }
    
    // App information
    Map<String, dynamic>? appInfo;
    if (json.data["appInfo"] is Map) {
      appInfo = Map<String, dynamic>.from(json.data["appInfo"]);
    }
    
    // Check if a custom production error widget is specified
    if (json.data["productionWidget"] != null) {
      // Use custom production widget if provided
      final productionWidget = json.data["productionWidget"];
      if (productionWidget is Map<String, dynamic>) {
        final productionJson = Json.fromJson(productionWidget);
        return application
            .make<JsonBuilder>(productionJson.type)
            .build(productionJson, context) as material.Widget;
      }
    }
    
    // Check if custom error view is specified
    if (json.data["customErrorView"] != null) {
      final customViewJson = Json.fromJson(json.data["customErrorView"]);
      return application
          .make<JsonBuilder>(customViewJson.type)
          .build(customViewJson, context) as material.Widget;
    }
    // Use the default PingErrorView
    //TODO currently it is not possible to make this widget from api. It will stay until we have covered all widget That PingErrorView can be created from api
    return PingErrorView(
      error: error,
      stackTrace: stackTrace,
      requestInfo: requestInfo,
      context: contextData,
      appInfo: appInfo,
      debugMode: application.make<StateManager>(WireDefinition.stateManager).get('device_info_state', 'build_mode') == 'debug',
      showFullDetails: json.data["showFullDetails"] ?? true,
      onReport: json.data["onReport"] != null && json.data["onReport"] is String
          ? () {
              // Execute the specified action when report button is pressed
            }
          : null,
    );
  }
} 