import 'package:flutter_ping_wire/src/framework/app.dart';
import 'package:flutter_ping_wire/src/framework/provider.dart';
import 'package:flutter_ping_wire/src/wire/builders/change_notifier_builder.dart';

import '../builders/page_builder.dart';
import '../builders/preferred_size_widget_builder.dart';
import '../builders/value_builder.dart';
import '../builders/widget_builder.dart';
import '../definitions/json.dart';
import '../executors/action_executor.dart';

class JsonBuilderProvider extends Provider {
  @override
  void register(Application app) {
    app.singleton(JsonDefinition.container, () => ContainerBuilder(app));
    app.singleton(JsonDefinition.row, () => RowBuilder(app));
    app.singleton(JsonDefinition.column, () => ColumnBuilder(app));
    app.singleton(JsonDefinition.text, () => TextBuilder(app));
    app.singleton(JsonDefinition.scaffold, () => ScaffoldBuilder(app));
    app.singleton(
        JsonDefinition.elevatedButton, () => ElevatedButtonBuilder(app));
    app.singleton(JsonDefinition.bottomNavigationBar,
        () => BottomNavigationBarBuilder(app));
    app.singleton(JsonDefinition.iconData, () => IconDataBuilder(app));
    app.singleton(JsonDefinition.sizedBox, () => SizedBoxBuilder(app));
    app.singleton(
        JsonDefinition.gestureDetector, () => GestureDetectorBuilder(app));
    app.singleton(JsonDefinition.listView, () => ListViewBuilder(app));
    app.singleton(JsonDefinition.gridView, () => GridViewBuilder(app));
    app.singleton(JsonDefinition.card, () => CardBuilder(app));
    app.singleton(JsonDefinition.singleChildScrollView,
        () => SingleChildScrollViewBuilder(app));
    app.singleton(JsonDefinition.imageNetwork, () => ImageNetworkBuilder(app));
    app.singleton(
        JsonDefinition.reactiveWidget, () => ReactiveWidgetBuilder(app));
    app.singleton(JsonDefinition.form, () => FormBuilder(app));
    app.singleton(
        JsonDefinition.textFormField, () => TextFormFieldBuilder(app));
    app.singleton(JsonDefinition.circularProgressIndicator,
        () => CircularProgressIndicatorBuilder(app));
    app.singleton(
        JsonDefinition.statelessWidget, () => StatelessWidgetBuilder(app));
    app.singleton(JsonDefinition.materialApp, () => MaterialAppBuilder(app));
    app.singleton(
        JsonDefinition.materialAppRouter, () => MaterialAppRouterBuilder(app));
    app.singleton(JsonDefinition.bottomAppBar, () => BottomAppBarBuilder(app));
    app.singleton(
        JsonDefinition.intrinsicHeight, () => IntrinsicHeightBuilder(app));
    app.singleton(JsonDefinition.floatingActionButton,
        () => FloatingActionButtonBuilder(app));
    app.singleton(JsonDefinition.imageAsset, () => ImageAssetBuilder(app));
    app.singleton(JsonDefinition.expanded, () => ExpandedBuilder(app));
    app.singleton(JsonDefinition.visibility, () => VisibilityBuilder(app));
    app.singleton(JsonDefinition.clipRRect, () => ClipRRectBuilder(app));
    app.singleton(JsonDefinition.padding, () => PaddingBuilder(app));

    // page builders
    app.singleton(JsonDefinition.materialPage, () => MaterialPageBuilder(app));

    // preferred size widget builders
    app.singleton(JsonDefinition.appBar, () => AppBarBuilder(app));

    // change notifier builders
    app.singleton(
        JsonDefinition.scrollController, () => ScrollControllerBuilder(app));

    //TODO make element_executor_provider
    app.singleton(JsonDefinition.alertAction, () => AlertActionExecutor(app));

    // dynamic value builders

    app.singleton(
        JsonDefinition.scopeValueBuilder, () => ScopeValueBuilder(app));
    app.singleton(
        JsonDefinition.stateValueBuilder, () => StateValueBuilder(app));
    app.singleton(
        JsonDefinition.notifierValueBuilder, () => NotifierValueBuilder(app));

    app.singleton(
        JsonDefinition.navigationAction, () => NavigationActionExecutor(app));

    app.singleton(JsonDefinition.networkRequestAction,
        () => NetworkRequestActionExecutor(app));

    app.singleton(JsonDefinition.eventDispatchAction,
        () => EventDispatchActionExecutor(app));

    app.singleton(JsonDefinition.updateReactiveWidgetAction,
        () => UpdateReactiveWidgetActionExecutor(app));

    app.singleton(JsonDefinition.validateAndSubmitAction,
        () => ValidateAndSubmitActionExecutor(app));

    app.singleton(JsonDefinition.functionCallAction,
        () => FunctionCallActionExecutor(app));
  }
}
