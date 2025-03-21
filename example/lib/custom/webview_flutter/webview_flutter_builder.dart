part of 'webview_flutter.dart';

class WebviewFlutterBuilder extends WidgetBuilder {
  WebviewFlutterBuilder(super.application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    application.make<StateManager>(WireDefinition.stateManager).bindScope("WebViewController", {
      "onPageStarted_url": "",
      "onPageFinished_url": "",
    });
    List<String> visitedUrls = [];

    final controller = pkg.WebViewController()
      ..setJavaScriptMode(pkg.JavaScriptMode.unrestricted)
      ..setBackgroundColor(const material.Color(0x00000000))
      ..setNavigationDelegate(
        pkg.NavigationDelegate(
            onProgress: (int progress) {
              json.data["onProgress"] == null
                  ? null
                  : application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(Event.fromJson(json.data["onProgress"]["data"]));
            },
            onPageStarted: (String url) {
              application.make<StateManager>(WireDefinition.stateManager).set("scoped_state_WebViewController", "onPageStarted_url", url);
              json.data["onPageStarted"] == null
                  ? null
                  : application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(Event.fromJson(json.data["onPageStarted"]["data"]));
            },
            onPageFinished: (String url) {
              visitedUrls.add(url);
              application.make<StateManager>(WireDefinition.stateManager).set("scoped_state_WebViewController", "onPageFinished_url",
                  {
                    "history": visitedUrls.join(","),
                    "url": url,
                  });
              json.data["onPageFinished"] == null
                  ? null
                  : application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(Event.fromJson(json.data["onPageFinished"]["data"]));
            },
            onWebResourceError: (pkg.WebResourceError error) {
              json.data["onWebResourceError"] == null
                  ? null
                  : application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(Event.fromJson(json.data["onWebResourceError"]["data"]));
            },
            onNavigationRequest: (pkg.NavigationRequest request) {
              //TODO implement this
              return pkg.NavigationDecision.navigate;
            },
            onUrlChange: (pkg.UrlChange urlChange) {
              json.data["onUrlChange"] == null
                  ? null
                  : application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(Event.fromJson(json.data["onUrlChange"]["data"]));
            }),
      )
      ..loadRequest(Uri.parse(json.data["url"]),
          headers: application.make<Client>(json.data["clientName"] ?? "app_client").getState().mergeHeaders(null));

    return pkg.WebViewWidget(
      controller: controller,
    );
  }
}
