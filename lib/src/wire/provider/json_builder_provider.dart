import 'package:flutter_ping_wire/src/framework/app.dart';
import 'package:flutter_ping_wire/src/framework/provider.dart';
import 'package:flutter_ping_wire/src/wire/builders/api_path_builder.dart';
import 'package:flutter_ping_wire/src/wire/builders/change_notifier_builder.dart';
import 'package:flutter_ping_wire/src/wire/builders/navigation_path_builder.dart';
import 'package:flutter_ping_wire/src/wire/builders/validator_builder.dart';

import '../builders/input_decoration_builder.dart';
import '../builders/page_builder.dart';
import '../builders/preferred_size_widget_builder.dart';
import '../builders/value_builder.dart';
import '../builders/widget_builder.dart';
import '../definitions/json.dart';
import '../executors/action_executor.dart';

class JsonBuilderProvider extends FrameworkServiceProvider {
  @override
  int get priority => 45; // Slightly lower than WireProvider
  
  @override
  void register(Application app) {
    app.singleton(JsonDefinition.container, () => ContainerBuilder(app));
    app.singleton(
        JsonDefinition.stringValueBuilder, () => StringValueBuilder(app));
    app.singleton(JsonDefinition.apiPathBuilder, () => ApiPathBuilder(app));
    app.singleton(
        JsonDefinition.navigationPathBuilder, () => NavigationPathBuilder(app));
    app.singleton(JsonDefinition.row, () => RowBuilder(app));
    app.singleton(JsonDefinition.column, () => ColumnBuilder(app));
    app.singleton(JsonDefinition.text, () => TextBuilder(app));
    app.singleton(JsonDefinition.scaffold, () => ScaffoldBuilder(app));
    app.singleton(
        JsonDefinition.elevatedButton, () => ElevatedButtonBuilder(app));
    app.singleton(JsonDefinition.bottomNavigationBar,
        () => BottomNavigationBarBuilder(app));
    app.singleton(JsonDefinition.iconData, () => IconDataBuilder(app));
    app.singleton(JsonDefinition.icon, () => IconBuilder(app));
    app.singleton(JsonDefinition.sizedBox, () => SizedBoxBuilder(app));
    app.singleton(JsonDefinition.placeholder, () => PlaceholderBuilder(app));
    app.singleton(JsonDefinition.fractionallySizedBox,
        () => FractionallySizedBoxBuilder(app));
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
    app.singleton(
        JsonDefinition.checkboxFormField, () => CheckboxFormFieldBuilder(app));
    app.singleton(JsonDefinition.radioGroupFormField,
        () => RadioGroupFormFieldBuilder(app));
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
    app.singleton(
        JsonDefinition.radioListTile, () => RadioListTileBuilder(app));
    app.singleton(JsonDefinition.listTile, () => ListTileBuilder(app));
    app.singleton(
        JsonDefinition.pingFormField, () => PingFormFieldBuilder(app));
    app.singleton(JsonDefinition.overlay, () => OverlayBuilder(app));
    app.singleton(JsonDefinition.center, () => CenterBuilder(app));

    // Register PingErrorBuilder
    app.singleton(JsonDefinition.pingErrorView, () => PingErrorBuilder(app));

    //paintings builders
    app.singleton(JsonDefinition.inputDecorationBuilder,
        () => InputDecorationBuilder(app));

    // page builders
    app.singleton(JsonDefinition.materialPage, () => MaterialPageBuilder(app));

    // preferred size widget builders
    app.singleton(JsonDefinition.appBar, () => AppBarBuilder(app));

    // change notifier builders
    app.singleton(
        JsonDefinition.scrollController, () => ScrollControllerBuilder(app));

    //TODO make element_executor_provider
    app.singleton(JsonDefinition.alertAction, () => AlertActionExecutor(app));
    app.singleton(
        JsonDefinition.loadingAction, () => LoadingActionExecutor(app));

    // dynamic value builders

    app.singleton(
        JsonDefinition.scopeValueBuilder, () => ScopeValueBuilder(app));
    app.singleton(
        JsonDefinition.stateValueBuilder, () => StateValueBuilder(app));
    app.singleton(
        JsonDefinition.notifierValueBuilder, () => NotifierValueBuilder(app));
    app.singleton(
        JsonDefinition.dynamicStringValueBuilder, () => DynamicStringValueBuilder(app));
    app.singleton(
        JsonDefinition.dynamicValueBuilder, () => DynamicValueBuilder(app));
    app.singleton(JsonDefinition.evalValueBuilder, () => EvalValueBuilder(app));
    app.singleton(JsonDefinition.valueListenableBuilder,
        () => ValueListenableBuilder(app));

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

    app.singleton(JsonDefinition.modalBottomSheetAction,
        () => ModalBottomSheetActionExecutor(app));

    app.singleton(
        JsonDefinition.updateStateAction, () => UpdateStateActionExecutor(app));

    app.singleton(JsonDefinition.updateNotifierAction,
        () => UpdateNotifierActionExecutor(app));

    app.singleton(JsonDefinition.submitAction, () => SubmitActionExecutor(app));

    app.singleton(JsonDefinition.validateAndSaveFormAction,
        () => ValidateAndSaveFormActionExecutor(app));

    app.singleton(JsonDefinition.dialogAction,
        () => DialogActionExecutor(app));

    // form field validators
    app.singleton(
        JsonDefinition.composeValidator, () => ComposerValidatorBuilder(app));
    app.singleton(
        JsonDefinition.requiredValidator, () => RequiredValidatorBuilder(app));
    app.singleton(
        JsonDefinition.emailValidator, () => EmailValidatorBuilder(app));
    app.singleton(JsonDefinition.minLengthValidator,
        () => MinLengthValidatorBuilder(app));
    app.singleton(JsonDefinition.maxLengthValidator,
        () => MaxLengthValidatorBuilder(app));
    app.singleton(
        JsonDefinition.lengthValidator, () => LengthValidatorBuilder(app));
    app.singleton(
        JsonDefinition.rangeValidator, () => RangeValidatorBuilder(app));
    app.singleton(
        JsonDefinition.regexValidator, () => RegexValidatorBuilder(app));
  }
  
  @override
  Future<void> boot(Application app) async {
    // Initialize any JsonBuilder dependencies after everything else is registered
    // This is intentionally empty as registration is enough for this provider,
    // but we could add boot-time initialization if needed in the future
  }
}
