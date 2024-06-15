import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../definitions/wire.dart';
import '../event_listeners/action_event_listener.dart';
import '../event_listeners/state_event_listener.dart';
import '../executors/action_executor.dart';
import '../form_state.dart';
import '../resources/widgets/form_widget.dart';
import '../resources/widgets/stateless_widget.dart';
import '../resources/widgets/text_input.dart';
import '../state.dart' as base_state;
import '../models/element.dart';
import '../models/event.dart';
import '../resources/rendering/basic_types.dart';
import '../resources/widgets/reactive_widget.dart';
import '../resources/widgets/reactive_widget_manager.dart';
import '../state_manager.dart';
import '../stream.dart';
import '../value.dart';
import 'element_builder.dart';
import 'preferred_size_widget_builder.dart';
import 'router_config_builder.dart';
import '../resources/ui/color.dart';
import '../resources/paintings/decoration.dart';
import '../resources/rendering/flex.dart';
import '../resources/paintings/edge_insets.dart';
import '../resources/paintings/text_style.dart';

part 'widget_builders/widget_builder.dart';

part 'widget_builders/container_builder.dart';

part 'widget_builders/row_builder.dart';

part 'widget_builders/column_builder.dart';

part 'widget_builders/text_builder.dart';

part 'widget_builders/scaffold_builder.dart';

part 'widget_builders/dynamic_widget_builder.dart';

part 'widget_builders/elevated_button_builder.dart';

part 'widget_builders/bottom_navigation_bar_builder.dart';

part 'widget_builders/icon_data_builder.dart';

part 'widget_builders/sized_box_builder.dart';

part 'widget_builders/gesture_detector_builder.dart';

part 'widget_builders/list_view_builder.dart';

part 'widget_builders/reactive_widget_builder.dart';

part 'widget_builders/form_widget.dart';

part 'widget_builders/text_form_field_builder.dart';

part 'widget_builders/circular_progress_indicator_builder.dart';

part 'widget_builders/stateless_widget_builder.dart';

part 'widget_builders/material_app_builder.dart';

part 'widget_builders/material_app_router_builder.dart';