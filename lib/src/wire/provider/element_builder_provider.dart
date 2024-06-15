import 'package:flutter_ping_wire/src/framework/app.dart';
import 'package:flutter_ping_wire/src/framework/provider.dart';

import '../builders/page_builder.dart';
import '../builders/preferred_size_widget_builder.dart';
import '../builders/widget_builder.dart';
import '../definitions/element.dart';
import '../executors/action_executor.dart';

class ElementBuilderProvider extends Provider {
  @override
  void register(Application app) {
    app.singleton(ElementDefinition.container, () => ContainerBuilder(app));
    app.singleton(ElementDefinition.row, () => RowBuilder(app));
    app.singleton(ElementDefinition.column, () => ColumnBuilder(app));
    app.singleton(ElementDefinition.text, () => TextBuilder(app));
    app.singleton(ElementDefinition.scaffold, () => ScaffoldBuilder(app));
    app.singleton(
        ElementDefinition.dynamicWidget, () => DynamicWidgetBuilder(app));
    app.singleton(
        ElementDefinition.elevatedButton, () => ElevatedButtonBuilder(app));
    app.singleton(ElementDefinition.bottomNavigationBar,
        () => BottomNavigationBarBuilder(app));
    app.singleton(ElementDefinition.iconData, () => IconDataBuilder(app));
    app.singleton(ElementDefinition.sizedBox, () => SizedBoxBuilder(app));
    app.singleton(
        ElementDefinition.gestureDetector, () => GestureDetectorBuilder(app));
    app.singleton(ElementDefinition.listView, () => ListViewBuilder(app));
    app.singleton(
        ElementDefinition.reactiveWidget, () => ReactiveWidgetBuilder(app));
    app.singleton(ElementDefinition.form, () => FormBuilder(app));
    app.singleton(
        ElementDefinition.textFormField, () => TextFormFieldBuilder(app));
    app.singleton(ElementDefinition.circularProgressIndicator,
        () => CircularProgressIndicatorBuilder(app));
    app.singleton(
        ElementDefinition.statelessWidget, () => StatelessWidgetBuilder(app));
    app.singleton(ElementDefinition.materialApp, () => MaterialAppBuilder(app));
    app.singleton(ElementDefinition.materialAppRouter,
        () => MaterialAppRouterBuilder(app));
    app.singleton(
        ElementDefinition.materialPage, () => MaterialPageBuilder(app));
    app.singleton(ElementDefinition.appBar, () => AppBarBuilder(app));

    //TODO make element_executor_provider
    app.singleton(
        ElementDefinition.alertAction, () => AlertActionExecutor(app));

    app.singleton(ElementDefinition.navigationAction,
        () => NavigationActionExecutor(app));

    app.singleton(ElementDefinition.networkRequestAction,
        () => NetworkRequestActionExecutor(app));

    app.singleton(ElementDefinition.eventDispatchAction,
        () => EventDispatchActionExecutor(app));

    app.singleton(ElementDefinition.updateReactiveWidgetAction,
        () => UpdateReactiveWidgetActionExecutor(app));

    app.singleton(ElementDefinition.validateAndSubmitAction,
        () => ValidateAndSubmitActionExecutor(app));
  }
}
