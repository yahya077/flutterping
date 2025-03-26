import 'package:example/generated/l10n.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

class LocalizationProvider extends Provider {
  LocalizationProvider();

  @override
  void register(Application app) {
    app.singleton("GlobalMaterialLocalizations",
        () => GlobalMaterialLocalizationsDelegateBuilder(app));
    app.singleton("GlobalWidgetsLocalizations",
        () => GlobalWidgetsLocalizationsDelegateBuilder(app));
    app.singleton("GlobalCupertinoLocalizations",
        () => GlobalCupertinoLocalizationsDelegateBuilder(app));
    app.singleton("l10nDelegate", () => l10nDelegateBuilder(app));
  }
}

class GlobalMaterialLocalizationsDelegateBuilder
    extends LocalizationDelegateBuilder {
  GlobalMaterialLocalizationsDelegateBuilder(Application application)
      : super(application);

  @override
  material.LocalizationsDelegate build(
      Json json, material.BuildContext? context) {
    return GlobalMaterialLocalizations.delegate;
  }
}

class GlobalWidgetsLocalizationsDelegateBuilder
    extends LocalizationDelegateBuilder {
  GlobalWidgetsLocalizationsDelegateBuilder(Application application)
      : super(application);

  @override
  material.LocalizationsDelegate build(
      Json json, material.BuildContext? context) {
    return GlobalWidgetsLocalizations.delegate;
  }
}

class GlobalCupertinoLocalizationsDelegateBuilder
    extends LocalizationDelegateBuilder {
  GlobalCupertinoLocalizationsDelegateBuilder(Application application)
      : super(application);

  @override
  material.LocalizationsDelegate build(
      Json json, material.BuildContext? context) {
    return GlobalCupertinoLocalizations.delegate;
  }
}

class l10nDelegateBuilder extends LocalizationDelegateBuilder {
  l10nDelegateBuilder(Application application) : super(application);

  @override
  material.LocalizationsDelegate build(
      Json json, material.BuildContext? context) {
    return S.delegate;
  }
}
