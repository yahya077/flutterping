import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:flutter/material.dart' as material;
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherProvider extends Provider {
  UrlLauncherProvider();

  @override
  void register(Application app) {
    app.singleton("UrlLauncherAction", () => LaunchUrlActionExecutor(app));
  }
}

class LaunchUrlActionExecutor extends ActionExecutor {
  LaunchUrlActionExecutor(super.application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final Uri uri = Uri.parse(json.data["url"]);

    if (!await launchUrl(uri, mode: _buildMode(json.data["mode"]))) {
      //TODO create on failure action
      throw Exception('Could not launch $uri');
    }

    if (json.data["thenAction"] != null) {
      await application
          .make<ActionExecutor>(json.data["thenAction"]["type"])
          .execute(context, Json.fromJson(json.data["thenAction"]));
    }
  }

  _buildMode(String? mode) {
    switch (mode) {
      case "externalNonBrowserApplication":
        return LaunchMode.externalNonBrowserApplication;
      case "externalApplication":
        return LaunchMode.externalApplication;
      case "inAppWebView":
        return LaunchMode.inAppWebView;
      case "inAppBrowserView":
        return LaunchMode.inAppBrowserView;
      default:
        return LaunchMode.platformDefault;
    }
  }
}
